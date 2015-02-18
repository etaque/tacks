package models

import reactivemongo.core.commands.LastError

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.DateTime
import reactivemongo.bson._
import tools.BSONHandlers._


object TournamentState extends Enumeration {
  type State = Value
  val open, finished = Value
}

case class Tournament(
  _id: BSONObjectID,
  masterId: BSONObjectID,
  name: String,
  meetTime: Option[DateTime],
  description: Option[String],
  state: TournamentState.State
) extends HasId

case class RichTournament(
  tournament: Tournament,
  master: Player,
  races: Seq[Race],
  users: Seq[User],
  leaderboard: Seq[TournamentRanking]
)

case class TournamentRanking(
  rank: Int,
  playerId: BSONObjectID,
  playerHandle: Option[String],
  points: Int
) extends WithPlayer

object Tournament extends MongoDAO[Tournament] {
  val collectionName = "tournaments"

  def update(t: Tournament): Future[LastError] = {
    update(t.id, BSONDocument(
      "name" -> t.name,
      "meetTime" -> t.meetTime,
      "description" -> t.description
    ))
  }

  def listOpen: Future[Seq[Tournament]] = {
    list(BSONDocument("state" -> TournamentState.open.toString), BSONDocument("meetTime" -> 1))
  }

  def listFinished: Future[Seq[Tournament]] = {
    list(BSONDocument("state" -> TournamentState.finished.toString), BSONDocument("meetTime" -> 1))
  }

  def enrich(tournaments: Seq[Tournament]): Future[Seq[RichTournament]] = {
    for {
      allRaces <- Race.listByTournamentIds(tournaments.map(_.id))
      allUsers <- User.listByIds(allRaces.flatMap(_.rankedPlayerIds) ++ tournaments.map(_.masterId))
    }
    yield {
      println("allRaces: " + allRaces)
      tournaments.map { t =>
        val races = allRaces.filter(_.tournamentId == t.id)
        val users = allUsers.filter(races.map(_.rankedPlayerIds).contains)
        val master = allUsers.find(_.id == t.masterId).getOrElse(Guest(t.masterId, None))
        RichTournament(t, master, races, users, leaderboard(races))
      }
    }
  }

  def leaderboard(races: Seq[Race]): Seq[TournamentRanking] = {
    races.flatMap(_.rankings).groupBy(_.playerId).map {
      case (playerId, raceRankings) => {
        val sum = raceRankings.map(_.points).sum
        val playerHandle = raceRankings.flatMap(_.playerHandle).headOption
        (playerId, playerHandle, sum)
      }
    }.toSeq.sortBy(_._3).reverse.zipWithIndex.map {
      case ((playerId, playerHandle, points), rank) => {
        TournamentRanking(rank + 1, playerId, playerHandle, points)
      }
    }
  }

  implicit object stateHandler extends BSONHandler[BSONString, TournamentState.State] {
    def read(value: BSONString) = TournamentState.withName(value.value)
    def write(state: TournamentState.State) = BSONString(state.toString)
  }

  implicit val bsonReader: BSONDocumentReader[Tournament] = Macros.reader[Tournament]
  implicit val bsonWriter: BSONDocumentWriter[Tournament] = Macros.writer[Tournament]
}

