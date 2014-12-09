import akka.actor.ActorRef
import models.{PlayerState, PlayerInput, Player}

package object actors {

  case class PlayerContext(player: Player, input: PlayerInput, state: PlayerState, ref: ActorRef)
  case class PlayerJoin(player: Player)
  case class PlayerQuit(player: Player)

  case object FrameTick
  case object SpawnGust
  case object GetStatus
  case object AutoClean

}
