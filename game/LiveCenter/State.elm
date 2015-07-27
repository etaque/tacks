module LiveCenter.State where

import Game exposing (Course, Player, defaultPlayer)

type alias State =
  { courses: List RaceCourseStatus
  , currentPlayer: Player
  , course: Maybe RaceCourse
  }

emptyState : State
emptyState =
  { courses = []
  , currentPlayer = defaultPlayer
  , course = Nothing
  }

type alias RaceCourseStatus =
  { raceCourse: RaceCourse
  , opponents: List Player
  }

type alias RaceCourse =
  { id: String
  , slug: String
  , course: Course
  , countdown: Int
  , startCycle: Int
  }

