module AppTypes where

import Task exposing (Task)
import Http

import Models exposing (..)

import Screens.Home.HomeTypes as Home
import Screens.Login.LoginTypes as Login
import Screens.Register.RegisterTypes as Register
import Screens.ShowTrack.ShowTrackTypes as ShowTrack


type alias AppSetup =
  { player : Player
  , path : String
  }


type AppAction
  = SetPlayer Player
  | SetPath String
  | HomeAction Home.Action
  | LoginAction Login.Action
  | RegisterAction Register.Action
  | ShowTrackAction ShowTrack.Action
  | Logout
  | NoOp


type alias AppUpdate =
  { appState : AppState
  , reaction : Maybe (Task Http.Error ())
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
  | NotFoundScreen String
  | NoScreen


type alias ScreenUpdate screen =
  { screen : screen
  , reaction : Maybe (Task Http.Error ())
  , request : Maybe AppAction
  }


local : screen -> ScreenUpdate screen
local screen =
  { screen = screen
  , reaction = Nothing
  , request = Nothing
  }


react : screen -> Task Http.Error () -> ScreenUpdate screen
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


screenToAppUpdate : AppState -> (screen -> AppScreen) -> ScreenUpdate screen -> AppUpdate
screenToAppUpdate appState toAppScreen {screen, reaction, request} =
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
