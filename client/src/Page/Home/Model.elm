module Page.Home.Model (..) where

import Model.Shared exposing (..)


type alias Model =
  { raceReports : List RaceReport
  }


initial : Model
initial =
  { raceReports = []
  }


type Action
  = SetRaceReports (Result () (List RaceReport))
  | NoOp
