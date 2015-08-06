module AppTypes where

import Task exposing (Task)
import Http

import Models exposing (..)

import Screens.Home.HomeTypes as Home
import Screens.Login.LoginTypes as Login
import Screens.Register.RegisterTypes as Register


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
