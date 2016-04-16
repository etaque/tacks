package actors

import java.util.UUID
import scala.concurrent.duration._
import scala.concurrent.Future
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor._
import akka.pattern.pipe
import org.joda.time.DateTime

import models._
import dao._
import tools.Conf


object TrackAction {
  sealed trait Action

  case class InitGhost(player: Player, run: Run, path: RunPath) extends Action

  case object FrameTick extends Action
  case object SpawnGust extends Action
  case class SaveRun(race: Race, ctx: PlayerContext, path: Option[RunPath]) extends Action
  case object RotateNextRace extends Action
  case object GetStatus extends Action
  case class LiveTrackUpdate(liveTrack: LiveTrack) extends Action
  case class ReloadTrack(track: Track) extends Action
  case object NoOp extends Action
}

class TrackActor(trackInit: Track) extends Actor with ManageWind {

  val creationTime = trackInit.creationTime

  var state = TrackState(
    track = trackInit,
    races = Nil,
    players = Map.empty,
    paths = Map.empty,
    playersGhosts = Map.empty,
    ghostRuns = Map.empty
  )

  def track = state.track
  def course = track.course

  def clock: Long = DateTime.now.getMillis

  val ticks = Seq(
    Akka.system.scheduler.schedule(1.second, 1.second, self, TrackAction.RotateNextRace),
    Akka.system.scheduler.schedule(0.seconds, course.gustGenerator.interval.seconds, self, TrackAction.SpawnGust),
    Akka.system.scheduler.schedule(0.seconds, Conf.frameMillis.milliseconds, self, TrackAction.FrameTick)
  )

  def receive = {

    case PlayerAction(player, action) =>
      import PlayerAction._
      action match {

        case NoOp =>
          // do nothing

        case Join =>
          state = state.addPlayer(player, sender)
          broadcastLiveTrackUpdate()

        case Input(PlayerInput(opState, _, clientTime)) =>
          state.players.get(player.id).foreach { context =>
            val newContext = context.copy(state = opState)

            state = state.updatePlayer(player.id, newContext, clock)

            if (context.state.crossedGates != newContext.state.crossedGates) {
              state = state.gateCrossedUpdate(newContext)
              state.playerRace(player.id).foreach { race =>
                if (newContext.state.hasFinished(track.course)) {
                  val saveRun = TrackAction.SaveRun(race, newContext, state.paths.lift(newContext.player.id))
                  Akka.system.scheduler.scheduleOnce(5.second, self, saveRun)
                }
              }
              broadcastLiveTrackUpdate()
            }

            context.ref ! raceUpdateForPlayer(player, clientTime)
          }

        case Quit =>
          state = state.removePlayer(player)
          broadcastLiveTrackUpdate()

        case StartRace =>
          state = state.startCountdown(player.id)

        case ExitRace =>
          state = state.escapePlayer(player.id)

        case NewMessage(content) =>
          val msg = Message(player, content, DateTime.now)
          state.players.foreach { case (_, ctx) =>
            ctx.ref ! msg
          }

        case AddGhost(runId) =>
          state.ghostRuns.get(runId) match {
            case Some((run, path)) =>
              self ! TrackAction.InitGhost(player, run, path)
            case None =>
              val initMaybeFu = for {
                runOpt <- Runs.findById(runId)
                pathOpt <- RunPaths.findByRunId(runId)
              } yield for {
                run <- runOpt
                path <- pathOpt
              } yield TrackAction.InitGhost(player, run, path)
              initMaybeFu.map(_.getOrElse(NoOp)).pipeTo(self)
          }

        case RemoveGhost(runId) =>
          state = state.removeGhost(player, runId)
      }

    case trackAction: TrackAction.Action => {
      import TrackAction._

      trackAction match {

        case FrameTick =>
          updateWind()

        case SaveRun(race, ctx, maybePath) =>
          val lastKnownPath = state.paths.lift(ctx.player.id).orElse(maybePath)
          TrackActor.saveRun(track, race, ctx, lastKnownPath)

        case InitGhost(player, run, path) =>
          state = state.addGhost(player, run, path)

        case SpawnGust =>
          generateGust()

        case RotateNextRace =>
          state = state.cleanStaleRaces()
          broadcastLiveTrackUpdate()

        case GetStatus =>
          (sender ! (state.races, state.players.values.map(_.asOpponent)))

        case LiveTrackUpdate(liveTrack) =>
          state.players.foreach { case (_, ctx) =>
            ctx.ref ! liveTrack
          }

        case ReloadTrack(newTrack) =>
          state = state.reloadTrack(newTrack)

        case NoOp =>
      }
    }
  }

  private def broadcastLiveTrackUpdate(): Future[TrackAction.LiveTrackUpdate] = {
    trackMeta(track).map { meta =>
      val liveTrack = LiveTrack(track, meta, state.races, state.listPlayers)
      TrackAction.LiveTrackUpdate(liveTrack)
    }.pipeTo(self)
  }

  def raceUpdateForPlayer(player: Player, clientTime: Long) = {
    val now = DateTime.now
    val startTimeOpt = state.playerStartTime(player)
    val raceTimeOpt = startTimeOpt.map(now.getMillis - _.getMillis)
    val ghosts = raceTimeOpt.map(state.playerGhosts(player.id)).getOrElse(Nil)
    RaceUpdate(
      serverNow = now,
      startTime = startTimeOpt,
      wind = wind,
      opponents = state.playerOpponents(player.id),
      ghosts = ghosts,
      tallies = state.playerTallies(player.id),
      clientTime = clientTime.toFloat
    )
  }

  override def postStop() = {
    ticks.foreach(_.cancel())
  }
}

object TrackActor {
  def props(track: Track) = Props(new TrackActor(track))

  def saveRun(track: Track, race: Race, ctx: PlayerContext, pathMaybe: Option[RunPath]): Future[Unit] = {
    val run = Run(
      id = UUID.randomUUID(),
      trackId = track.id,
      raceId = race.id,
      playerId = ctx.player.id,
      playerHandle = ctx.player.handleOpt,
      startTime = race.startTime,
      tally = ctx.state.crossedGates,
      duration = ctx.state.crossedGates.headOption.getOrElse(0)
    )
    for {
      userMaybe <- Users.findById(ctx.player.id)
      if userMaybe.isDefined
      _ <- pathMaybe.map(_.copy(runId = run.id)).map(savePathIfBest(track.id, ctx.player.id)).getOrElse(Future.successful(()))
      _ <- Runs.save(run)
    }
    yield ()
  }

  def savePathIfBest(trackId: UUID, playerId: UUID)(path: RunPath): Future[Unit] = {
    for {
      bestMaybe <- Runs.findBestOnTrackForPlayer(trackId, playerId).map(_.headOption)
      _ <- bestMaybe.map(r => RunPaths.deleteByRunId(r.id)).getOrElse(Future.successful(()))
      _ <- RunPaths.save(path)
    }
    yield ()
  }
}
