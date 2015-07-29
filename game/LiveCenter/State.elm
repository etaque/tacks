module LiveCenter.State where


import Game exposing (..)


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

type alias ServerInput =
  { raceCourses: List RaceCourseStatus
  , currentPlayer: Player
  -- , onlinePlayers: List Player
  }
