module Screens.Admin.Types where

import Models exposing (..)
import Routes
import Transit exposing (Transition)


type alias Screen = Transit.WithTransition
  { tracks : List Track
  , users : List User
  , route : Routes.AdminRoute
  }

initial : Screen
initial =
  { tracks = []
  , users = []
  , transition = Transit.empty
  , route = Routes.Dashboard
  }

type Action
  = RefreshData
  | RefreshDataResult (Result () AdminData)
  | DeleteTrack String
  | DeleteTrackResult (FormResult String)
  | TransitionAction Transit.Action
  | NoOp

