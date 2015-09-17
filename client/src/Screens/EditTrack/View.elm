module Screens.EditTrack.View where

import Html exposing (Html)

import Svg exposing (..)
import Svg.Attributes exposing (..)

import AppTypes exposing (..)
import Models exposing (..)

import Screens.EditTrack.Types exposing (..)
import Screens.EditTrack.Updates exposing (actions)

import Screens.Utils exposing (..)
import Screens.Messages exposing (..)

import Game.Geo exposing (floatify)
import Game.Render.Utils exposing (..)
import Game.Render.SvgUtils exposing (..)

import Game.RenderSvg.Tiles exposing (lazyRenderTiles, tileKindColor)


view : Screen -> Html
view screen =
  case screen.editor of
    Just editor ->
      renderEditor screen.dims editor
    Nothing ->
      wrapper screen.dims
        [ text'
          [ x <| toString (fst screen.dims // 2)
          , y <| toString (snd screen.dims // 2)
          ]
          [ text "loading" ]
        ]

renderEditor : (Int, Int) -> Editor -> Html
renderEditor dims ({dims, center} as editor) =
  let
    (w, h) = floatify dims
    cx = w / 2 + fst center
    cy = h / 2 + snd center
  in
    wrapper dims
    [ g [ transform ("translate(" ++ toString cx ++ ", " ++ toString cy ++ ")")]
        [ (lazyRenderTiles editor.grid) ]
    , renderMode editor.mode
    ]

wrapper : (Int, Int) -> List Svg -> Html
wrapper (w, h) items =
  Svg.svg
    [ width (toString w)
    , height (toString h)
    , fill "black"
    ]
    items

renderMode : Mode -> Svg
renderMode mode =
  let
    color =
      case mode of
        CreateTile kind ->
          tileKindColor kind
        Erase ->
          colorToSvg colors.sand
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

