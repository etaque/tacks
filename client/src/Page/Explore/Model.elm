module Page.Explore.Model (..) where

import Model.Shared exposing (..)
import Dialog


type alias Model =
  { showTrackRanking : Maybe LiveTrack
  , dialog : Dialog.Model
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
