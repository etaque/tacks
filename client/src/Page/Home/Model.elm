module Page.Home.Model (..) where

import Model.Shared exposing (..)


type alias Model =
  { trackFocus : Maybe TrackId
  , raceReports : List RaceReport
  }


initial : Model
initial =
  { trackFocus = Nothing
  , raceReports = []
  }


type Action
  = SetRaceReports (Result () (List RaceReport))
  | FocusTrack (Maybe TrackId)
  | NoOp
