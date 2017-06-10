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
    svg
        [ width (toString w)
        , height (toString h)
        , version "1.1"
        ]
        [ defs
            []
            [ linearGradient
                [ id "transparentToBlack"
                ]
                [ stop [ offset "0%", stopColor "black", stopOpacity "0" ] []
                , stop [ offset "100%", stopColor "black", stopOpacity "1" ] []
                ]
            ]
        , g
            [ class "wind-origin"
            , transform (translate (toFloat w / 2) 50)
            ]
            [ WindOriginGauge.render h playerState.windOrigin ]
        ]
