module Game.Render.Dashboard.WindOriginGauge exposing (..)

import Game.Render.SvgUtils exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)


windGaugeCy : Float
windGaugeCy =
    500


render : Int -> Float -> Svg msg
render h windOrigin =
    let
        cy =
            (toFloat h / 2)
    in
        g
            [ opacity "0.5"
            ]
            [ renderRuledArc
            , g [ transform <| rotate_ windOrigin 0 windGaugeCy ]
                [ renderWindArrow
                , renderWindOriginText windOrigin
                ]
            ]


renderWindArrow : Svg msg
renderWindArrow =
    Svg.path
        [ d "M 0,0 4,-15 0,-12 -4,-15 Z"
        , fill "black"
        ]
        []


renderWindOriginText : Float -> Svg msg
renderWindOriginText origin =
    text_
        [ textAnchor "middle"
        , x "0"
        , y "15"
        , fontSize "12px"
        ]
        [ text <| toString (round origin) ++ "°" ]


renderRuledArc : Svg msg
renderRuledArc =
    let
        tick l r =
            segment
                [ stroke "black", opacity "0.5", transform (rotate_ r 0 windGaugeCy) ]
                ( ( 0, 0 ), ( 0, -l ) )

        smallTick =
            tick 5

        bigTick =
            tick 7.5
    in
        g []
            [ renderWindArc
            , smallTick -15
            , bigTick -10
            , smallTick -5
            , bigTick 0
            , smallTick 5
            , bigTick 10
            , smallTick 15
            ]


renderWindArc : Svg msg
renderWindArc =
    arc
        [ stroke "black"
        , strokeWidth "1"
        , fillOpacity "0"
        ]
        { center = ( 0, 500 )
        , radius = windGaugeCy
        , fromAngle = -17.5
        , toAngle = 17.5
        }
