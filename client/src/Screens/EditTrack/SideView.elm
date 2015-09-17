module Screens.EditTrack.SideView where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Screens.EditTrack.Updates exposing (actions)
import Screens.EditTrack.Types exposing (..)

sideView : Editor -> Html
sideView ({dims} as editor) =
  aside [ style [("height", toString (snd dims) ++ "px")] ]
    [ button
        [ onClick actions.address Save ]
        [ text "Save" ]
    ]


