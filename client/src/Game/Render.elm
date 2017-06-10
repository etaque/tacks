module Game.Render exposing (..)

import Constants
import Game.Render.Course as Course
import Game.Render.Dashboard as Dashboard
import Game.Render.Players as Players
import Game.Render.SvgUtils as SvgUtils
import Game.Render.LayerDef as LayerDef
import Game.Shared exposing (..)
import Html as H exposing (Html)
import Html.Attributes as HA
import Svg exposing (..)
import Svg.Attributes exposing (..)


layers : ( Int, Int ) -> GameState -> List (Html msg)
layers ( w, h ) ({ playerState, course, wind } as gameState) =
    let
        cx =
            (toFloat w) / 2 - (Tuple.first gameState.center)

        cy =
            (toFloat h) / 2 - (toFloat h) - (Tuple.second gameState.center)
    in
        [ Course.courseGridLayer ( w, h ) gameState
        , Course.courseLayer ( w, h ) gameState
        , dashboardLayer ( w, h ) gameState
        ]



-- H.div
-- [ HA.class "game-layers" ]
-- [ H.div
--     [ HA.class "svg-container" ]
--     [ svg
--         [ width (toString w)
--         , height (toString h)
--         , version "1.1"
--         ]
--         [ g
--             [ transform ("scale(1,-1)" ++ (SvgUtils.translate cx cy)) ]
--             [ Players.renderPlayers gameState ]
--         ]
--     ]
-- ]


dashboardLayer : ( Int, Int ) -> GameState -> Html msg
dashboardLayer ( w, h ) gameState =
    H.div
        [ HA.class "svg-container dashboard-layer" ]
        [ Dashboard.renderDashboard ( w, h ) gameState
        ]
