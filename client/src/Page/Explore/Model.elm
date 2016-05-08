module Page.Explore.Model (..) where

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


type Action
  = NoOp
  | ShowTrackRanking LiveTrack
  | DialogAction Dialog.Action
