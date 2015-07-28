module LiveCenter.State where


import Game exposing (Player, defaultPlayer, Opponent)


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
  , opponents: List Opponent
  }

type alias RaceCourse =
  { id: String
  , slug: String
  -- , course: Course
  , countdown: Int
  , startCycle: Int
  }


type alias ServerInput =
  { raceCourses: List RaceCourseStatus
  , currentPlayer: Player
  -- , onlinePlayers: List Player
  }
