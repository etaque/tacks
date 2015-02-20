package models

import org.joda.time.DateTime

object Tutorial {
  sealed trait Step

  case object InitialStep extends Step
  case object CourseStep extends Step
  case object TurningStep extends Step
  case object TheoryStep extends Step
  case object GateStep extends Step
  case object LapStep extends Step
  case object VmgStep extends Step
  case object LockStep extends Step
  case object FinalStep extends Step

  val steps = Seq(InitialStep, CourseStep, TurningStep, GateStep, LapStep, VmgStep, LockStep, TheoryStep, FinalStep)
  val runningSteps = Seq(CourseStep, LapStep, VmgStep, LockStep)

  def isRunning(s: Step) = runningSteps.contains(s)

  def courseForStep(step: Step, input: TutorialInput): Course = {
    step match {
      case _ => {
        val (w,h) = input.window
//        val m = 20
//        val area = RaceArea(rightTop = (w/4 - m, h/2 - m), leftBottom = (-w/4 + m, -h/2 + m))
//        Course(
//          upwind = Gate(area.top - 100, 100),
//          downwind = Gate(area.bottom + 100, 100),
//          laps = 1,
//          islands = Seq(Island((-area.left / 2, area.cy), 50)),
//          area = area,
//          windGenerator = WindGenerator.empty,
//          gustGenerator = GustGenerator.empty
//        )
        val upwind = Gate(h/2 - 150, 100)
        val downwind = Gate(-h/2 + 50, 100)
        Course(
          upwind = upwind,
          downwind = downwind,
          laps = 1,
          islands = Seq(Island((-200, upwind.y - 200), 50)),
          area = RaceArea(rightTop = (600, 1000), leftBottom = (-600, -1000)),
          windGenerator = WindGenerator.empty,
          gustGenerator = GustGenerator.empty
        )
      }
    }
  }
}

case class TutorialUpdate(
  now: Long,
  playerState: PlayerState,
  course: Option[Course],
  step: Tutorial.Step,
  messages: Option[Seq[(String, String)]] = None
)

object TutorialUpdate {
  def initial(p: Player, messages: Map[String, String]) = TutorialUpdate(
    now = DateTime.now.getMillis,
    playerState = PlayerState.initial(p),
    course = None,
    step = Tutorial.InitialStep,
    messages = Some(messages.toSeq)
  )
}

case class TutorialInput(
  keyboard: KeyboardInput,
  step: Tutorial.Step,
  window: (Int,Int)
)

object TutorialInput {
  def initial = TutorialInput(KeyboardInput.initial, Tutorial.InitialStep, (0,0))
}
