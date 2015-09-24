module Screens.EditTrack.View where

import Html exposing (Html)
import Html.Attributes as HtmlAttr

import Svg exposing (..)
import Svg.Attributes exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Constants exposing (..)

import Screens.EditTrack.Types exposing (..)
import Screens.EditTrack.Updates exposing (actions)
import Screens.EditTrack.SideView exposing (sideView)

import Screens.Utils exposing (..)
import Screens.Messages exposing (..)

import Game.Grid as Grid
import Game.Geo exposing (floatify)
import Game.Render.Utils exposing (..)
import Game.Render.SvgUtils exposing (..)

import Game.RenderSvg.Tiles as RenderTiles exposing (lazyRenderTiles, tileKindColor)
import Game.RenderSvg.Gates exposing (renderOpenGate)
import Game.RenderSvg.Players exposing (renderPlayerHull)

view : Screen -> Html
view screen =
  case screen.editor of
    Just editor ->
      editorView editor
    Nothing ->
      Html.text "loading"


editorView : Editor -> Html
editorView editor =
  Html.div [ class "content editor" ]
    [ sideView editor
    , renderCourse editor
    ]


renderCourse : Editor -> Html
renderCourse ({courseDims, center, course} as editor) =
  let
    (w, h) = floatify courseDims
    cx = w / 2 + fst center
    cy = -h / 2 + snd center
  in
    Svg.svg
      [ width (toString w)
      , height (toString h)
      ]
      [ g [ transform ("scale(1,-1)" ++ (translate cx cy)) ]
        [ (lazyRenderTiles course.grid)
        , renderOpenGate course.upwind 0
        , renderOpenGate course.downwind 0
        , renderPlayerHull 0 0
        ]
      , renderMode editor.mode
      ]


renderMode : Mode -> Svg
renderMode mode =
  let
    color =
      case mode of
        CreateTile kind ->
          tileKindColor kind
        Erase ->
          colors.sand
        Watch ->
          "white"
  in
    circle
      [ r "20"
      , fill color
      , stroke "black"
      , strokeWidth "2"
      , cx "50"
      , cy "50"
      ]
      []

