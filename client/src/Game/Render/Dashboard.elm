module Game.Render.Dashboard exposing (..)

import Game.Shared exposing (..)
import Game.Render.SvgUtils exposing (..)
import Game.Render.Dashboard.WindSpeedGraph as WindSpeedGraph
import Game.Render.Dashboard.WindOriginGauge as WindOriginGauge
import Game.Render.Dashboard.VmgBar as VmgBar
import Game.Render.Dashboard.Status as Status
import Svg exposing (..)
import Svg.Attributes exposing (..)


renderDashboard : ( Int, Int ) -> GameState -> Svg msg
renderDashboard ( w, h ) ({ playerState } as gameState) =
    g
        [ class "dashboard"
        ]
        [ g
            [ class "wind-origin"
            , transform (translate (toFloat w / 2) 50)
            ]
            [ WindOriginGauge.render h playerState.windOrigin ]
          -- , g
          --     [ class "wind-speed"
          --     , transform (translate 30 30)
          --     ]
          --     [ WindSpeedGraph.render gameState.timers.serverTime playerState.windSpeed gameState.windHistory ]
          -- , g
          --     [ class "vmg"
          --     , transform (translate (toFloat w - VmgBar.barWidth - 40) 40)
          --     ]
          --     [ VmgBar.render gameState.playerState ]
        ]
