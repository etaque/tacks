module Page.Explore.Model exposing (..)

import Model.Shared exposing (..)
import Dialog


type alias Model =
    Dialog.WithDialog
        { showTrackRanking : Maybe LiveTrack
        }


initial : Model
initial =
    { showTrackRanking = Nothing
    , dialog = Dialog.initial
    }


type Msg
    = NoOp
    | ShowTrackRanking LiveTrack
    | DialogMsg Dialog.Msg
