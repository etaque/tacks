module Page.Home.Model exposing (..)

import Model.Shared exposing (..)
import Dialog exposing (WithDialog)


type alias Model =
  WithDialog
    { raceReports : List RaceReport
    , showDialog : Dialog
    }


type Dialog
  = Empty
  | RankingDialog LiveTrack
  | ReportDialog RaceReport


initial : Model
initial =
  { raceReports = []
  , showDialog = Empty
  , dialog = Dialog.initial
  }


type Msg
  = SetRaceReports (Result () (List RaceReport))
  | ShowDialog Dialog
  | DialogMsg Dialog.Msg
  | NoOp
