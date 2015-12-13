module Screens.EditTrack.SideView where

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import Constants exposing (..)
import Screens.Utils exposing (..)
import Routes exposing (..)

import Screens.EditTrack.Updates exposing (addr)
import Screens.EditTrack.Types exposing (..)
import Screens.Sidebar as Sidebar

import Game.Render.Tiles as RenderTiles exposing (tileKindColor)


view : Track -> Editor -> List Html
view track ({course, name, saving, mode, blocks} as editor) =
  [ Sidebar.logo

  , div
      [ class "track-menu" ]
      [ hr'
      , h2 [] [ text name ]
      , hr'
      ]

  , sideBlock "Name" blocks.name (ToggleBlock Name)
    [ div [ class "form-group"]
      [ nameInput name ]
    ]

  , sideBlock "Surface pencil" blocks.surface (ToggleBlock Surface)
    [ surfaceBlock editor
    ]

  , sideBlock "Gates" blocks.gates (ToggleBlock Gates)
    [ div [ class "form-group"]
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
    ]

  , sideBlock "Wind" blocks.wind (ToggleBlock Wind)
    [ div [ class "form-group" ]
      [ label [ class "" ] [ text "Speed" ]
      , intInput course.windSpeed SetWindSpeed [ HtmlAttr.min "10", HtmlAttr.max "20" ]
      ]
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
    ]

  , sideBlock "Gusts" blocks.gusts (ToggleBlock Gusts)
    [ div [ class "form-group" ]
      [ label [ class "" ] [ text "Interval (s)" ]
      , intInput course.gustGenerator.interval SetGustInterval [ HtmlAttr.min "10"]
      ]
    , gustDefsTable course.gustGenerator.defs
    ]

  , div [ class "form-actions" ]
    [ button
      [ onClick addr (Save False)
      , class "btn btn-primary btn-block btn-save"
      , disabled saving
      ]
      [ text "Save" ]
    , button
      [ onClick addr (Save True)
      , class "btn btn-default btn-block btn-save-and-try"
      , disabled saving
      ]
      [ text "Save and try" ]
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
      , onClick addr (SetMode mode)
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
      [ a [ onClick addr (FormAction CreateGustDef) ]
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
        [ a [ onClick addr (FormAction (RemoveGustDef i)) ]
            [ text "-" ]
        ]
    ]


nameInput : String -> Html
nameInput n =
  textInput
    [ value n
    , onInput addr SetName
    , type' "text"
    ]


intInput : number -> (Int -> FormUpdate) -> List Attribute -> Html
intInput val formUpdate attrs =
  textInput
   ([ value (toString val)
    , onIntInput addr (formUpdate >> FormAction)
    , type' "number"
    ] ++ attrs)


sideBlock : String -> Bool -> Action -> List Html -> Html
sideBlock title open action content =
  div [ classList [ ("aside-module", True), ("closed", not open) ] ] <|
  [ div [ class "module-header" ]
    [ a [ class "module-title", onClick addr action ]
      [ text title
      , span [ class <| "glyphicon glyphicon-" ++ if open then "chevron-down" else "chevron-right" ] []
      ]
    ]
  , div [ class "module-body" ] content
  ]
