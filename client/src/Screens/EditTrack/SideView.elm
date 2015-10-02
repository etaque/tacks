module Screens.EditTrack.SideView where

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import Constants exposing (..)
import Screens.Utils exposing (..)

import Screens.EditTrack.Updates exposing (actions)
import Screens.EditTrack.Types exposing (..)

import Game.Render.Tiles as RenderTiles exposing (tileKindColor)


sideView : Track -> Editor -> Html
sideView track ({courseDims, course, name, saving, mode} as editor) =
  sidebar (sidebarWidth, snd courseDims)
    [ div
        [ class "track-menu" ]
        [ h2 [] [ text "track editor" ]
        , linkTo "/" [ class "btn btn-xs btn-default" ] [ text "Exit" ]
        , linkTo ("/play/" ++ track.id) [ class "btn btn-xs btn-default" ] [ text "Try" ]
        ]

    , div [ class "form-actions" ]
      [ button
        [ onClick actions.address Save
        , class "btn btn-primary btn-block"
        , disabled saving
        ]
        [ text (if saving then "Saving.." else "Save") ]
      ]

    , div [ class "aside-module" ]

      [ h3 [] [ text "Name" ]

      , div [ class "form-group"]
        [ nameInput name ]

      , h3 [] [ text "Surface pencil" ]

      , surfaceBlock editor

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
    ]


surfaceBlock : Editor -> Html
surfaceBlock editor =
  let
    modes = [ Watch, CreateTile Water, CreateTile Rock, CreateTile Grass, Erase ]
    currentMode = realMode editor
  in
    div [ class "surface-modes" ]
      (List.map (renderSurfaceMode currentMode) modes)


renderSurfaceMode : Mode -> Mode -> Html
renderSurfaceMode currentMode mode =
  let
    color = case mode of
      CreateTile kind ->
        tileKindColor kind
      Erase ->
        colors.sand
      Watch ->
        "white"
    (abbr, label) = modeName mode
  in
    a [ classList  [ ("current", currentMode == mode), (abbr, True) ]
      , onClick actions.address (SetMode mode)
      , style [ ("background-color", color) ]
      , title label
      ]
      [ text abbr ]


gustDefsTable : List GustDef -> Html
gustDefsTable defs =
  table
    [ class "table-gust-defs" ]
    (gustDefsHeader :: List.indexedMap gustDefRow defs)


gustDefsHeader : Html
gustDefsHeader =
  tr []
    [ th [] [ text "angle" ]
    , th [] [ text "speed" ]
    , th [] [ text "radius" ]
    , th [ class "action" ]
      [ a [ onClick actions.address (FormAction CreateGustDef) ]
          [ text "+" ]
      ]
    ]


gustDefRow : Int -> GustDef -> Html
gustDefRow i def =
  tr []
    [ td [] [ intInput def.angle (SetGustAngle i) [ ] ]
    , td [] [ intInput def.speed (SetGustSpeed i) [ ] ]
    , td [] [ intInput def.radius (SetGustRadius i) [ HtmlAttr.min "10", step "10" ] ]
    , td [ class "action" ]
        [ a [ onClick actions.address (FormAction (RemoveGustDef i)) ]
            [ text "-" ]
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

