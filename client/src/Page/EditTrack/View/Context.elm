module Page.EditTrack.View.Context exposing (..)

import Html exposing (..)
import Html.App exposing (map)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Constants exposing (..)
import View.Utils as Utils exposing (..)
import Page.EditTrack.Model exposing (..)
import Page.EditTrack.View.Gates as Gates
import Page.EditTrack.View.Gusts as Gusts
import Page.EditTrack.View.Wind as Wind
import Game.Render.Tiles as RenderTiles exposing (tileKindColor)
import Route


toolbar : Track -> Editor -> List (Html Msg)
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
          , onInput SetName
          ]
          []
      ]
  , surfaceBlock editor
  , div [ class "toolbar-right" ] []
  ]


view : Track -> Editor -> List (Html Msg)
view track ({ course } as editor) =
  (actions track editor)
    :: (tabs editor.tab)
    :: case editor.tab of
        GatesTab ->
          List.map (map FormMsg) (Gates.view editor.currentGate course)

        WindTab ->
          List.map (map FormMsg) (Wind.view editor)

        GustsTab ->
          List.map (map FormMsg) (Gusts.view track editor)


actions : Track -> Editor -> Html Msg
actions track editor =
  div
    [ class "actions" ]
    [ a
        [ onClick (Save False)
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
        [ onClick (Save True)
        , class "btn-raised btn-white btn-save-and-try"
        , disabled editor.saving
        ]
        [ Utils.mIcon "gamepad" [], text "Test" ]
    ]


tabs : Tab -> Html Msg
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
      (\t -> onClick (SetTab t))
      ((==) tab)


surfaceBlock : Editor -> Html Msg
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


renderSurfaceMode : Mode -> Mode -> Html Msg
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
      , onButtonClick (SetMode mode)
      , title label
      ]
      [ span
          [ style [ ( "color", color ) ]
          ]
          [ Utils.mIcon icon [] ]
      , text label
      ]
