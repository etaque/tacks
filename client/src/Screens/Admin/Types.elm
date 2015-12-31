module Screens.Admin.Types where

import Transit exposing (Transition)

import Models exposing (..)
import Screens.Admin.Routes exposing (..)


type alias Screen = Transit.WithTransition
  { tracks : List Track
  , users : List User
  , route : Route
  }

initialRoute : Route
initialRoute =
  Dashboard

initial : Screen
initial =
  { tracks = []
  , users = []
  , transition = Transit.initial
  , route = initialRoute
  }

type Action
  = RefreshData
  | RefreshDataResult (Result () AdminData)
  | DeleteTrack String
  | DeleteTrackResult (FormResult String)
  | StartTransition Route
  | UpdateRoute Route
  | TransitionAction (Transit.Action Action)
  | NoOp

