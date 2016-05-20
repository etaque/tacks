module View.Logo exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Game.Render.Players as Players
import Game.Render.Tiles as Tiles


render : Svg msg
render =
  svg
    [ width "50"
    , height "50"
    , viewBox "-25 -25 50 50"
    ]
    [ polygon
        [ points (Tiles.toSvgPoints (Tiles.vertices 10))
        , class "hexagon"
        ]
        []
    , Players.hull
    ]
