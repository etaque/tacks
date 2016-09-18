module Game.Render.Dashboard.VmgBar exposing (..)

import Game.Models exposing (..)
import Game.Render.SvgUtils exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)


barWidth =
    150


barHeight =
    5


render : PlayerState -> Svg msg
render playerState =
    let
        coef =
            vmgCoef playerState

        contour =
            g
                [ stroke "black" ]
                [ segment [ stroke "black" ] ( ( 0, 0 ), ( barWidth, 0 ) )
                , segment [ stroke "black" ] ( ( 0, 0 ), ( 0, barHeight ) )
                , segment [ stroke "black" ] ( ( barWidth, 0 ), ( barWidth, barHeight ) )
                , segment [ stroke "black" ] ( ( -5, barHeight ), ( barWidth + 5, barHeight ) )
                ]

        bar =
            rect
                [ width (toString (barWidth * coef))
                , height (toString barHeight)
                  -- , fill "url(#midBlack)"
                , fill "black"
                , opacity "1"
                ]
                []

        label =
            text'
                [ textAnchor "middle"
                , x (toString (barWidth * coef))
                , y (toString (barHeight + 15))
                , fontSize "12px"
                ]
                [ text <| toString (floor (coef * 100)) ++ "%" ]
    in
        g
            [ opacity "0.5" ]
            [ contour
            , bar
            , label
            ]


vmgCoef : PlayerState -> Float
vmgCoef { windAngle, velocity, vmgValue, downwindVmg, upwindVmg } =
    let
        theoricVmgValue =
            if (abs windAngle) < 90 then
                upwindVmg.value
            else
                downwindVmg.value

        boundedVmgValue =
            if vmgValue > theoricVmgValue then
                theoricVmgValue
            else if vmgValue < 0 then
                0
            else
                vmgValue
    in
        if theoricVmgValue == 0 then
            0
        else
            boundedVmgValue / theoricVmgValue
