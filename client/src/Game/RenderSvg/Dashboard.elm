module Game.RenderSvg.Dashboard where

import Game.Models exposing (..)
import Game.Core exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)
import Game.RenderSvg.Gates exposing (..)

import Game.RenderSvg.Dashboard.WindSpeedGraph as WindSpeedGraph
import Game.RenderSvg.Dashboard.WindOriginGauge as WindOriginGauge
import Game.RenderSvg.Dashboard.VmgBar as VmgBar

import String
import List exposing (..)
import Maybe as M

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)


renderDashboard : (Int,Int) -> GameState -> Svg
renderDashboard (w,h) gameState =
  g [ ]
    [ text'
        [ textAnchor "middle"
        , x (toString (w // 2))
        , y (toString (h - 50))
        , fontSize "32px"
        , opacity "0.8"
        ]
        [ text (getTimer gameState) ]

    , g [ transform (translatePoint (toFloat w / 2, 30)) ]
        [ WindOriginGauge.render h gameState.wind ]

    , g [ transform (translate 30 30)]
        [ WindSpeedGraph.render gameState.now gameState.wind gameState.windHistory ]

    , g [ transform (translate (toFloat w - VmgBar.barWidth - 40) 40)]
        [ VmgBar.render gameState.playerState ]
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


