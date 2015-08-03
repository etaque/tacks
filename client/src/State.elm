module State where

import Game exposing (..)
import Forms.Model exposing (Forms)


type Screen
  = Home
  | Show RaceCourseStatus
  | ShowProfile Player
  | Play RaceCourse

type alias AppState =
  { screen : Screen
  , player : Player
  , courses : List RaceCourseStatus
  , forms : Forms
  , gameState : Maybe GameState
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

initialAppState : Player -> AppState
initialAppState player =
  { screen = Home
  , player = player
  , courses = []
  , forms = initialForms player
  , gameState = Nothing
  }

initialForms : Player -> Forms
initialForms player =
  { setHandle = { handle = Maybe.withDefault "" player.handle }
  , login = { email = "", password = "", error = False }
  }
