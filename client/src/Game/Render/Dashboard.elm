module Game.Render.Dashboard where

import Game.Models exposing (..)

import Game.Render.SvgUtils exposing (..)

import Game.Render.Dashboard.WindSpeedGraph as WindSpeedGraph
import Game.Render.Dashboard.WindOriginGauge as WindOriginGauge
import Game.Render.Dashboard.VmgBar as VmgBar
import Game.Render.Dashboard.Status as Status

import Svg exposing (..)
import Svg.Attributes exposing (..)


renderDashboard : (Int,Int) -> GameState -> Svg
renderDashboard (w,h) ({playerState} as gameState) =
  g [ class "dashboard" ]
    [ g [ class "status"
        , transform (translate (w // 2) 120)
        ]
        [ Status.render gameState ]

    , g [ class "wind-origin"
        , transform (translate (toFloat w / 2) 30)
        ]
        [ WindOriginGauge.render h playerState.windOrigin ]

    , g [ class "wind-speed"
        , transform (translate 30 30)
        ]
        [ WindSpeedGraph.render gameState.timers.now playerState.windSpeed gameState.windHistory ]

    , g [ class "vmg"
        , transform (translate (toFloat w - VmgBar.barWidth - 40) 40)
        ]
        [ VmgBar.render gameState.playerState ]
    ]
