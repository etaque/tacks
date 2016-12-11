module View.Logo exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Game.Render.SvgUtils as SvgUtils
import Game.Render.Players as Players
import Game.Render.Tiles as Tiles


render : Svg msg
render =
    svg
        (viewport ++ [ class "with-hull" ])
        [ hexagon
        , Players.hull
        ]


renderMenu : Svg msg
renderMenu =
    svg
        (viewport ++ [ class "with-menu" ])
        [ hexagon
        , g [ class "icon-menu" ]
            [ SvgUtils.segment [] ( ( -8, -4 ), ( 8, -4 ) )
            , SvgUtils.segment [] ( ( -8, 0 ), ( 8, 0 ) )
            , SvgUtils.segment [] ( ( -8, 4 ), ( 8, 4 ) )
            ]
        ]


hexagon : Svg msg
hexagon =
    polygon
        [ points (Tiles.toSvgPoints (Tiles.vertices 10))
        , class "hexagon"
        ]
        []


viewport : List (Attribute msg)
viewport =
    [ width "32"
    , height "48"
    , viewBox "-16 -24 32 48"
    ]
