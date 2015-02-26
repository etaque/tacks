import models.Player

package object actors {

  case class PlayerJoin(player: Player)
  case class PlayerQuit(player: Player)

  case object FrameTick
  case object SpawnGust
  case object GetStatus
  case object AutoClean

}
