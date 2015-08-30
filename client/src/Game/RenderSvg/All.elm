module Game.RenderSvg.All where

import Game.Models exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)

import Game.RenderSvg.Course exposing (..)
import Game.RenderSvg.Players exposing (..)
import Game.RenderSvg.Gates exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)



render : (Int, Int) -> GameState -> Html
render (w, h) ({playerState,course,now,wind} as gameState) =
  let
    cx = (toFloat w) / 2 - (fst gameState.center)
    cy = (toFloat h) / 2 - (toFloat h) - (snd gameState.center)
  in
    svg
      [ width (toString w)
      , height (toString h)
      , version "1.1"
      ]
      [ g
        [ transform ("scale(1,-1)" ++ (translate cx cy)) ]
        [ renderBounds course.area
        , renderGusts wind
        , renderIslands course
        , renderDownwind playerState course now (isStarted gameState)
        , renderUpwind playerState course now
        , g
          [ transform (translatePoint playerState.position) ]
          [ lazy renderPlayerHull playerState.heading ]
        ]
      ]










