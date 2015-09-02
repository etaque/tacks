module Game.RenderSvg.Dashboard where

import Game.Models exposing (..)
import Game.Core exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)
import Game.RenderSvg.Gates exposing (..)

import String
import List exposing (..)
import Maybe as M

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)


renderDashboard : (Int,Int) -> GameState  -> Svg
renderDashboard (w,h) gameState =
  g [ ]
    [ text'
        [ textAnchor "middle"
        , x (toString (w // 2))
        , y "50"
        , fontSize "32px"
        , opacity "0.8"
        ]
        [ text (getTimer gameState) ]
    ]

getTimer : GameState -> String
getTimer {startTime, now, playerState} =
  case startTime of
    Just t ->
      let
        timer =
          if isNothing playerState.nextGate then
            M.withDefault 0 (head playerState.crossedGates)
          else
            t - now
      in
        formatTimer timer (isNothing playerState.nextGate)
    Nothing -> "start pending"
















