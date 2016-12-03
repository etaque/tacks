module Game.Render.All exposing (..)

import Game.Models exposing (..)
import Game.Render.SvgUtils exposing (..)
import Game.Render.Defs exposing (..)
import Game.Render.Course exposing (..)
import Game.Render.Players exposing (..)
import Game.Render.Dashboard exposing (..)
import Game.Render.WebGL as GameWebGL
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


render : ( Int, Int ) -> GameState -> List (Html msg)
render ( w, h ) gameState =
    let
        ( cx, cy ) =
            gameState.center

        dx =
            toFloat w / 2 - cx

        dy =
            toFloat -h / 2 - cy

        viewport =
            GameWebGL.Viewport { width = w, height = h } 2 ( -cx, -cy )
    in
        [ svg
            [ width (toString w)
            , height (toString h)
            , version "1.1"
            ]
            [ renderDefs
            , g
                [ transform ("scale(1,-1)" ++ (translate dx dy)) ]
                [ renderCourse gameState
                , renderPlayers gameState
                ]
            , renderDashboard ( w, h ) gameState
            ]
        , GameWebGL.renderGrid viewport gameState.course.grid
        ]
