module Screens.Admin.Types where

import Models exposing (..)
import Routes


type alias Screen =
  { route : Routes.AdminRoute
  , tracks : List Track
  , users : List User
  }

initial : Routes.AdminRoute -> Screen
initial adminRoute =
  { route = adminRoute
  , tracks = []
  , users = []
  }

type Action
  = RefreshData
  | RefreshDataResult (Result () AdminData)
  | DeleteTrack String
  | DeleteTrackResult (FormResult String)
  | NoOp

