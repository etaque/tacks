module Screens.EditTrack.SideView where

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import Constants exposing (..)
import Screens.Utils exposing (..)

import Screens.EditTrack.Updates exposing (actions)
import Screens.EditTrack.Types exposing (..)


sideView : Editor -> Html
sideView ({courseDims, course, name} as editor) =
  sidebar (sidebarWidth, snd courseDims)
    [ div
        [ class "track-menu" ]
        [ h2 [] [ text "track editor" ] ]

    , div [ class "aside-module" ]

      [ h3 [] [ text "Name" ]

      , div [ class "form-group"]
        [ nameInput name ]

      , h3 [] [ text "Gates" ]

      , div [ class "form-group"]
        [ label [ class "" ] [ text "Downwind" ]
        , intInput course.downwind.y SetDownwindY [ step "10" ]
        ]
      , div [ class "form-group"]
        [ label [ class "" ] [ text "Upwind" ]
        , intInput course.upwind.y SetUpwindY [ step "10" ]
        ]
      , div [ class "form-group"]
        [ label [ class "" ] [ text "Width" ]
        , intInput course.downwind.width SetGateWidth [ HtmlAttr.min "50", step "10" ]
        ]
      , div [ class "form-group" ]
        [ label [ class "" ] [ text "Laps" ]
        , intInput course.laps SetLaps [ HtmlAttr.min "1" ]
        ]

      , h3 [] [ text "Wind" ]

      , div [ class "form-group" ]
        [ label [ class "" ] [ text "Wavelength 1" ]
        , intInput course.windGenerator.wavelength1 SetWindW1 [ HtmlAttr.min "1" ]
        ]
      , div [ class "form-group" ]
        [ label [ class "" ] [ text "Amplitude 1" ]
        , intInput course.windGenerator.amplitude1 SetWindA1 [ HtmlAttr.min "1" ]
        ]
      , div [ class "form-group" ]
        [ label [ class "" ] [ text "Wavelength 2" ]
        , intInput course.windGenerator.wavelength2 SetWindW2 [ HtmlAttr.min "1" ]
        ]
      , div [ class "form-group" ]
        [ label [ class "" ] [ text "Amplitude 2" ]
        , intInput course.windGenerator.amplitude2 SetWindA2 [ HtmlAttr.min "1" ]
        ]

      , h3 [] [ text "Gusts" ]

      , div [ class "form-group" ]
        [ label [ class "" ] [ text "Interval (s)" ]
        , intInput course.gustGenerator.interval SetGustInterval [ HtmlAttr.min "10"]
        ]

      , gustDefsTable course.gustGenerator.defs

      ]
    , div [ class "form-actions" ]
        [ button
          [ onClick actions.address Save
          , class "btn btn-primary btn-block"
          ]
          [ text "Save" ]
        , linkTo "/" [ class "btn btn-block btn-default" ] [ text "Exit" ]
        ]
    ]


gustDefsTable : List GustDef -> Html
gustDefsTable defs =
  table
    [ class "table-gust-defs" ]
    ([ tr []
        [ th [] [ text "angle" ]
        , th [] [ text "speed" ]
        , th [] [ text "radius" ]
        , th [ class "action" ]
            [ a [ onClick actions.address (FormAction CreateGustDef) ]
              [ span [ class "glyphicon glyphicon-plus" ] [ ] ]
            ]
        ]
    ] ++ List.indexedMap gustDefRow defs)


gustDefRow : Int -> GustDef -> Html
gustDefRow i def =
  tr []
    [ td [] [ intInput def.angle (SetGustAngle i) [ ] ]
    , td [] [ intInput def.speed (SetGustSpeed i) [ ] ]
    , td [] [ intInput def.radius (SetGustRadius i) [ HtmlAttr.min "10", step "10" ] ]
    , td [ class "action" ]
        [ a [ onClick actions.address (FormAction (RemoveGustDef i)) ]
            [ span [ class "glyphicon glyphicon-minus" ] [ ] ]
        ]
    ]


nameInput : String -> Html
nameInput n =
  textInput
    [ value n
    , onInput actions.address SetName 
    , type' "text"
    ]


intInput : number -> (Int -> FormUpdate) -> List Attribute -> Html
intInput val formUpdate attrs =
  textInput
   ([ value (toString val)
    , onIntInput actions.address (formUpdate >> FormAction)
    , type' "number"
    ] ++ attrs)

