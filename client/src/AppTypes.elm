module AppTypes where

import Task exposing (Task)
import Http
import Dict exposing (Dict)

import Models exposing (..)

import Screens.Home.Types as Home
import Screens.Login.Types as Login
import Screens.Register.Types as Register
import Screens.ShowTrack.Types as ShowTrack
import Screens.ShowProfile.Types as ShowProfile
import Screens.Game.Types as Game


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
  | HomeAction Home.Action
  | LoginAction Login.Action
  | RegisterAction Register.Action
  | ShowTrackAction ShowTrack.Action
  | ShowProfileAction ShowProfile.Action
  | GameAction Game.Action
  | Logout
  | NoOp


type alias Clock =
  { delta : Float
  , time : Float
  }

type alias AppUpdate =
  { appState : AppState
  , reaction : Maybe (Task Never ())
  , request : Maybe AppAction
  }


type alias AppState =
  { player : Player
  , screen : AppScreen
  }


type AppScreen
  = HomeScreen Home.Screen
  | LoginScreen Login.Screen
  | RegisterScreen Register.Screen
  | ShowTrackScreen ShowTrack.Screen
  | ShowProfileScreen ShowProfile.Screen
  | GameScreen Game.Screen
  | NotFoundScreen String
  | NoScreen


type alias ScreenUpdate screen =
  { screen : screen
  , reaction : Maybe (Task Never ())
  , request : Maybe AppAction
  }

type alias FormResult a = Result FormErrors a

type alias FormErrors = Dict String (List String)

type Never = Never Never

local : screen -> ScreenUpdate screen
local screen =
  { screen = screen
  , reaction = Nothing
  , request = Nothing
  }


react : screen -> Task Never () -> ScreenUpdate screen
react screen task =
  { screen = screen
  , reaction = Just task
  , request = Nothing
  }


request : screen -> AppAction -> ScreenUpdate screen
request screen appAction =
  { screen = screen
  , reaction = Nothing
  , request = Just appAction
  }


mapAppUpdate : AppState -> (screen -> AppScreen) -> ScreenUpdate screen -> AppUpdate
mapAppUpdate appState toAppScreen {screen, reaction, request} =
  AppUpdate
    { appState | screen <- toAppScreen screen }
    reaction
    request


initialAppUpdate : Player -> AppUpdate
initialAppUpdate player =
  AppUpdate
    (initialAppState player)
    Nothing
    Nothing


initialAppState : Player -> AppState
initialAppState player =
  { player = player
  , screen = NoScreen
  }
