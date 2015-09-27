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
      [ h3 [] [ text "Gates" ]
      , div [ class "form-group"]
        [ label [ class "" ] [ text "Downwind" ]
        , textInput
          [ value <| toString course.downwind.y
          , onIntInput actions.address (SetDownwindY >> FormAction)
          , type' "number"
          , step "10"
          ]
        ]
      , div [ class "form-group"]
        [ label [ class "" ] [ text "Upwind" ]
        , textInput
          [ value <| toString course.upwind.y
          , onIntInput actions.address (SetUpwindY >> FormAction)
          , type' "number"
          , step "10"
          ]
        ]
      , div [ class "form-group"]
        [ label [ class "" ] [ text "Width" ]
        , textInput
          [ value <| toString course.downwind.width
          , onIntInput actions.address (SetGateWidth >> FormAction)
          , type' "number"
          , step "10"
          ]
        ]
      , div [ class "form-group" ]
        [ label [ class "" ] [ text "Laps" ]
        , textInput
          [ value <| toString course.laps
          , onIntInput actions.address (SetLaps >> FormAction)
          , type' "number"
          ]
        ]
      , h3 [] [ text "Wind" ]
      , button
        [ onClick actions.address Save
        , class "btn btn-primary btn-block"
        ]
        [ text "Save" ]
      ]
    ]


