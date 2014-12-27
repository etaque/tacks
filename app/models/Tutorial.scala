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

