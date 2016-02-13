module Page.Admin.Model where

import Model.Shared exposing (..)
import Page.Admin.Route exposing (..)


type alias Model =
  { tracks : List Track
  , users : List User
  }

initialRoute : Route
initialRoute =
  Dashboard

initial : Model
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

