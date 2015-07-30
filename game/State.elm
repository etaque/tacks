module State where

import Game exposing (..)


type Screen
  = Index
  | ShowLeaderboard RaceCourse
  | Play RaceCourse

type alias AppState =
  { screen : Screen
  , liveCenterState: LiveCenterState
  , gameState : Maybe GameState
  }

initialAppState : AppState
initialAppState =
  { screen = Index
  , liveCenterState =
    { player = defaultPlayer
    , courses = []
    }
  , gameState = Nothing
  }

type alias LiveCenterState =
  { player : Player
  , courses : List RaceCourseStatus
  }

type alias RaceCourseStatus =
  { raceCourse: RaceCourse
  , opponents: List Opponent
  }

type alias RaceCourse =
  { id: String
  , slug: String
  , course: Course
  , countdown: Int
  , startCycle: Int
  }
