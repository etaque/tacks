module Screens.EditTrack.SideView where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Constants exposing (..)
import Screens.Utils exposing (..)

import Screens.EditTrack.Updates exposing (actions)
import Screens.EditTrack.Types exposing (..)

sideView : Editor -> Html
sideView ({dims} as editor) =
  sidebar (sidebarWidth, snd dims)
    [ div [ class "aside-module" ]
      [ button
        [ onClick actions.address Save
        , class "btn btn-primary btn-block"
        ]
        [ text "Save" ]
      ]
    ]


