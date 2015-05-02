import akka.actor._
import models._

package object actors {

  case class PlayerContext(
    player: Player,
    input: KeyboardInput,
    state: OpponentState,
    ref: ActorRef
  ) {
    def asOpponent = Opponent(state, player)
  }

  case class PlayerJoin(player: Player)
  case class PlayerQuit(player: Player)

  case object FrameTick
  case object SpawnGust
  case object GetStatus
  case object AutoClean

}
