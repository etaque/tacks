module AppTypes where

import Task exposing (Task)
import Http

import Models exposing (..)

import Screens.Home.HomeTypes as Home
import Screens.Login.LoginTypes as Login
import Screens.Register.RegisterTypes as Register


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
  | NoOp


type alias AppUpdate =
  { appState : AppState
  , reaction : Maybe (Task Http.Error AppAction)
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
  | NotFoundScreen String
  | NoScreen


type alias ScreenUpdate screen action =
  { screen : screen
  , reaction : Maybe (Task Http.Error action)
  , request : Maybe AppAction
  }


local : screen -> ScreenUpdate screen action
local screen =
  { screen = screen
  , reaction = Nothing
  , request = Nothing
  }


react : screen -> Task Http.Error action -> ScreenUpdate screen action
react screen task =
  { screen = screen
  , reaction = Just task
  , request = Nothing
  }


request : screen -> AppAction -> ScreenUpdate screen action
request screen appAction =
  { screen = screen
  , reaction = Nothing
  , request = Just appAction
  }


screenToAppUpdate : AppState -> (screen -> AppScreen) -> (screenAction -> AppAction) -> ScreenUpdate screen screenAction -> AppUpdate
screenToAppUpdate appState toAppScreen toAppAction {screen, reaction, request} =
  AppUpdate
    { appState | screen <- toAppScreen screen }
    (Maybe.map (Task.map toAppAction) reaction)
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
