module Screens.Admin.Model where

import Models exposing (..)
import Screens.Admin.Routes exposing (..)


type alias Screen =
  { tracks : List Track
  , users : List User
  }

initialRoute : Route
initialRoute =
  Dashboard

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

