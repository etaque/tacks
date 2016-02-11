module Page.Admin.Model where

import Models exposing (..)
import Page.Admin.Route exposing (..)


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

