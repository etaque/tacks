module Screens.Admin.Types where

import Models exposing (..)
import Screens.Admin.Routes exposing (..)
import Transit exposing (Transition)


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
  , transition = Transit.empty
  , route = initialRoute
  }

type Action
  = RefreshData
  | RefreshDataResult (Result () AdminData)
  | DeleteTrack String
  | DeleteTrackResult (FormResult String)
  | TransitionAction Transit.Action
  | UpdateRoute Route
  | NoOp

