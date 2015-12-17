module Screens.Admin.Types where

import Models exposing (..)


type alias Screen =
  { tracks : List Track
  , users : List User
  }

initial : Screen
initial =
  { tracks = []
  , users = []
  }

type Action
  = RefreshData
  | RefreshDataResult (Result () AdminData)
  | DeleteTrack String
  | DeleteTrackResult (FormResult String)
  | NoOp

