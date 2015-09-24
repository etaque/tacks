module Game.Render.Dashboard where

import Game.Models exposing (..)
import Game.Core exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)
import Game.Render.Gates exposing (..)

import Game.Render.Dashboard.WindSpeedGraph as WindSpeedGraph
import Game.Render.Dashboard.WindOriginGauge as WindOriginGauge
import Game.Render.Dashboard.VmgBar as VmgBar

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
        [ WindSpeedGraph.render gameState.timers.now gameState.wind gameState.windHistory ]

    , g [ transform (translate (toFloat w - VmgBar.barWidth - 40) 40)]
        [ VmgBar.render gameState.playerState ]
    ]

getTimer : GameState -> String
getTimer {timers, playerState} =
  case timers.startTime of
    Just t ->
      let
        timer =
          if isNothing playerState.nextGate then
            M.withDefault 0 (head playerState.crossedGates)
          else
            t - timers.now
      in
        formatTimer timer (isNothing playerState.nextGate)
    Nothing -> "start pending"


