module AppTypes where

import Task exposing (Task)

import Models exposing (..)

import Screens.Home.Types as Home
import Screens.Login.Types as Login
import Screens.Register.Types as Register
import Screens.ShowTrack.Types as ShowTrack
import Screens.EditTrack.Types as EditTrack
import Screens.ShowProfile.Types as ShowProfile
import Screens.Game.Types as Game



appActionsMailbox : Signal.Mailbox AppAction
appActionsMailbox =
  Signal.mailbox AppNoOp


type alias AppSetup =
  { player : Player
  , path : String
  }


type alias AppInput =
  { action : AppAction
  , clock : Clock
  }


type AppAction
  = SetPlayer Player
  | SetPath String
  | PathChanged String
  | UpdateDims (Int, Int)
  | ScreenAction ScreenAction
  | Logout
  | AppNoOp


type ScreenAction
  = HomeAction Home.Action
  | LoginAction Login.Action
  | RegisterAction Register.Action
  | ShowTrackAction ShowTrack.Action
  | EditTrackAction EditTrack.Action
  | ShowProfileAction ShowProfile.Action
  | GameAction Game.Action

type alias Clock =
  { delta : Float
  , time : Float
  }

type alias AppUpdate =
  { appState : AppState
  , reaction : Maybe (Task Never ())
  }


type alias AppState =
  { player : Player
  , dims : (Int, Int)
  , screen : AppScreen
  }


type AppScreen
  = HomeScreen Home.Screen
  | LoginScreen Login.Screen
  | RegisterScreen Register.Screen
  | ShowTrackScreen ShowTrack.Screen
  | EditTrackScreen EditTrack.Screen
  | ShowProfileScreen ShowProfile.Screen
  | GameScreen Game.Screen
  | NotFoundScreen String
  | NoScreen


type alias ScreenUpdate screen =
  { screen : screen
  , reaction : Maybe (Task Never ())
  }

type Never = Never Never


local : screen -> ScreenUpdate screen
local screen =
  { screen = screen
  , reaction = Nothing
  }


react : screen -> Task Never () -> ScreenUpdate screen
react screen task =
  { screen = screen
  , reaction = Just task
  }


initialAppUpdate : (Int, Int) -> Player -> AppUpdate
initialAppUpdate dims player =
  AppUpdate
    (initialAppState dims player)
    Nothing


initialAppState : (Int, Int) -> Player -> AppState
initialAppState dims player =
  { player = player
  , screen = NoScreen
  , dims = dims
  }
