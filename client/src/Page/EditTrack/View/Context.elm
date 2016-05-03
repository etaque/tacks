module Page.EditTrack.View.Context (..) where

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Constants exposing (..)
import View.Utils as Utils exposing (..)
import Page.EditTrack.Update exposing (..)
import Page.EditTrack.Model exposing (..)
import Page.EditTrack.View.Utils exposing (..)
import Page.EditTrack.View.Gates as Gates
import Page.EditTrack.View.Gusts as Gusts
import Game.Render.Tiles as RenderTiles exposing (tileKindColor)
import Route


nav : Track -> Editor -> List Html
nav track editor =
  [ h2
      []
      [ linkTo
          (Route.ShowTrack track.id)
          []
          [ text track.name ]
      ]
  ]


toolbar : Track -> Editor -> List Html
toolbar track editor =
  [ div
      [ class "toolbar-left" ]
      [ linkTo
          Route.ListDrafts
          [ class "exit"
          , title "Back to drafts list"
          ]
          [ Utils.mIcon "arrow_back" [] ]
      , input
          [ type' "text"
          , class "edit-name"
          , value editor.name
          , Utils.onInput addr SetName
          ]
          []
      ]
  , surfaceBlock editor
  , div [ class "toolbar-right" ] []
  ]


view : Track -> Editor -> List Html
view track ({ course } as editor) =
  (actions track editor)
    :: (tabs editor.tab)
    :: case editor.tab of
        GatesTab ->
          Gates.view editor.currentGate course

        WindTab ->
          [ div
              [ class "wind-fields" ]
              [ div
                  [ class "form-group filled" ]
                  [ intInput course.windSpeed SetWindSpeed [ HtmlAttr.min "10", HtmlAttr.max "20" ]
                  , label [ class "" ] [ text "Speed" ]
                  ]
              , div
                  [ class "form-group" ]
                  [ intInput course.windGenerator.wavelength1 SetWindW1 [ HtmlAttr.min "1" ]
                  , label [ class "" ] [ text "Wavelength 1" ]
                  ]
              , div
                  [ class "form-group" ]
                  [ intInput course.windGenerator.amplitude1 SetWindA1 [ HtmlAttr.min "1" ]
                  , label [ class "" ] [ text "Amplitude 1" ]
                  ]
              , div
                  [ class "form-group" ]
                  [ intInput course.windGenerator.wavelength2 SetWindW2 [ HtmlAttr.min "1" ]
                  , label [ class "" ] [ text "Wavelength 2" ]
                  ]
              , div
                  [ class "form-group" ]
                  [ intInput course.windGenerator.amplitude2 SetWindA2 [ HtmlAttr.min "1" ]
                  , label [ class "" ] [ text "Amplitude 2" ]
                  ]
              ]
          ]

        GustsTab ->
          Gusts.view track editor


actions : Track -> Editor -> Html
actions track editor =
  div
    [ class "actions" ]
    [ a
        [ onClick addr (Save False)
        , class "btn-raised btn-primary btn-save"
        , disabled editor.saving
        ]
        [ Utils.mIcon
            (if editor.saving then
              "cached"
             else
              "save"
            )
            []
        , text "Save"
        ]
    , a
        [ onClick addr (Save True)
        , class "btn-raised btn-white btn-save-and-try"
        , disabled editor.saving
        ]
        [ Utils.mIcon "gamepad" [], text "Test" ]
    ]


tabs : Tab -> Html
tabs tab =
  let
    items =
      [ ( "Gates", GatesTab )
      , ( "Wind", WindTab )
      , ( "Gusts", GustsTab )
      ]
  in
    Utils.tabsRow
      items
      (\t -> onClick addr (SetTab t))
      ((==) tab)


surfaceBlock : Editor -> Html
surfaceBlock editor =
  let
    modes =
      [ Watch, CreateTile Water, CreateTile Rock, CreateTile Grass, Erase ]

    currentMode =
      realMode editor
  in
    div
      [ class "toolbar-center surface-modes" ]
      (List.map (renderSurfaceMode currentMode) modes)


renderSurfaceMode : Mode -> Mode -> Html
renderSurfaceMode currentMode mode =
  let
    color =
      case mode of
        CreateTile kind ->
          tileKindColor kind ( 0, 0 )

        Erase ->
          colors.sand

        Watch ->
          "white"

    icon =
      if mode == Watch then
        "pan_tool"
      else
        "lens"

    ( abbr, label ) =
      modeName mode
  in
    a
      [ classList [ ( "current", currentMode == mode ), ( abbr, True ) ]
      , onButtonClick addr (SetMode mode)
      , title label
      ]
      [ span
          [ style [ ( "color", color ) ]
          ]
          [ Utils.mIcon icon [] ]
      , text label
      ]
