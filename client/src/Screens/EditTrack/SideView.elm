module Screens.EditTrack.SideView where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Constants exposing (..)
import Screens.Utils exposing (..)

import Screens.EditTrack.Updates exposing (actions)
import Screens.EditTrack.Types exposing (..)

sideView : Editor -> Html
sideView ({courseDims, course} as editor) =
  sidebar (sidebarWidth, snd courseDims)
    [ div [ class "aside-module" ]
      [ div [ class "input-group"]
        [ span [ class "input-group-addon" ] [ text "Downwind" ]
        , textInput
          [ value <| toString course.downwind.y
          , onIntInput actions.address SetDownwindY
          , type' "number"
          , step "10"
          ]
        ]
      , br [] []
      , div [ class "input-group"]
        [ span [ class "input-group-addon" ] [ text "Upwind" ]
        , textInput
          [ value <| toString course.upwind.y
          , onIntInput actions.address SetUpwindY
          , type' "number"
          , step "10"
          ]
        ]
      , br [] []
      , div [ class "input-group"]
        [ span [ class "input-group-addon" ] [ text "Gates width" ]
        , textInput
          [ value <| toString course.downwind.width
          , onIntInput actions.address SetGateWidth
          , type' "number"
          , step "10"
          ]
        ]
      , br [] []
      , button
        [ onClick actions.address Save
        , class "btn btn-primary btn-block"
        ]
        [ text "Save" ]
      ]
    ]


