module Screens.Admin.Types where

import Models exposing (..)
import Routes
import Transition exposing (Transition)


type alias Screen = Transition.WithTransition
  { tracks : List Track
  , users : List User
  , route : Routes.AdminRoute
  }

initial : Screen
initial =
  { tracks = []
  , users = []
  , transition = Transition.empty
  , route = Routes.Dashboard
  }

type Action
  = RefreshData
  | RefreshDataResult (Result () AdminData)
  | DeleteTrack String
  | DeleteTrackResult (FormResult String)
  | TransitionAction Transition.Action
  | NoOp

