package models

import org.joda.time.DateTime

sealed trait TutorialStep
case object TurningStep extends TutorialStep
case object GateStep extends TutorialStep
case object LockStep extends TutorialStep

object TutorialStep {
  def initial = TurningStep
}

case class TutorialUpdate(
  now: Long,
  playerState: PlayerState,
  course: Option[Course],
  step: TutorialStep
)

object TutorialUpdate {
  def initial(p: Player) = TutorialUpdate(DateTime.now.getMillis, PlayerState.initial(p), Some(Course.forTutorial), TutorialStep.initial)
}

case class TutorialInput(
  keyboard: PlayerInput,
  step: TutorialStep,
  window: (Int,Int)
)

object TutorialInput {
  def initial = TutorialInput(PlayerInput.initial, TutorialStep.initial, (0,0))
}
