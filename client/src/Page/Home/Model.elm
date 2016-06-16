module Page.Home.Model exposing (..)

import Model.Shared exposing (..)
import Dialog exposing (WithDialog)


type alias Model =
  WithDialog
    { raceReports : HttpData (List RaceReport)
    , showDialog : Dialog
    , pokes : List Id
    }


type Dialog
  = Empty
  | RankingDialog LiveTrack
  | ReportDialog RaceReport


initial : Model
initial =
  { raceReports = Loading
  , showDialog = Empty
  , dialog = Dialog.initial
  , pokes = []
  }


type Msg
  = RaceReportsResult (HttpResult (List RaceReport))
  | ShowDialog Dialog
  | Poke Player
  | PokeEnd Id
  | DialogMsg Dialog.Msg
  | NoOp


canPoke : Player -> Player -> Bool
canPoke from target =
  from.user && target.user && from.id /= target.id
