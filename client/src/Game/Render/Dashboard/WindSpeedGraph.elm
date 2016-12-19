module Game.Render.Dashboard.WindSpeedGraph exposing (..)

import Game.Shared exposing (..)
import Game.Render.SvgUtils exposing (..)
import List exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)


graphWidth =
    200


windCoef =
    3


maxSpeed =
    25


timeScale : Float
timeScale =
    graphWidth / windHistoryLength


render : Float -> Float -> WindHistory -> Svg msg
render now windSpeed { lastSample, samples, init } =
    let
        steps =
            List.map (\{ time, speed } -> ( timeX init now time, speedY speed )) samples

        currentX =
            timeX init now now

        currentY =
            speedY windSpeed

        historyPath =
            Svg.path
                [ pathPoints (( currentX, currentY ) :: steps)
                , stroke "url(#transparentToBlack)"
                , strokeWidth "1"
                , strokeOpacity "0.8"
                , fillOpacity "0"
                ]
                []

        currentCircle =
            circle
                [ cx "0"
                , cy "0"
                , r "2"
                , fill "black"
                , transform <| translatePoint ( currentX, currentY )
                ]
                []

        currentText =
            text_
                [ textAnchor "left"
                , x (toString (currentX + 8))
                , y (toString (currentY + 3))
                , fontSize "12px"
                ]
                [ text <| toString (round windSpeed) ++ "kn" ]

        xMark =
            segment
                [ stroke "black"
                , opacity "0.5"
                ]
                ( ( currentX, speedY 8 ), ( currentX, speedY 27 ) )
    in
        g
            [ opacity "0.5"
            ]
            [ yMarks
            , xMark
            , historyPath
            , currentCircle
            , currentText
            ]


yMarks : Svg msg
yMarks =
    g
        [ opacity "0.2" ]
        [ renderMark True 10
        , renderMark False 15
        , renderMark True 20
        , renderMark False 25
        ]


renderMark : Bool -> Float -> Svg msg
renderMark solid speed =
    segment
        [ stroke "black"
        , strokeWidth "1"
        , strokeDasharray
            (if solid then
                ""
             else
                "3,3"
            )
        ]
        ( ( 0, speedY speed ), ( windHistoryLength * timeScale, speedY speed ) )


speedY : Float -> Float
speedY speed =
    (maxSpeed - speed) * windCoef


timeX : Float -> Float -> Float -> Float
timeX init now t =
    let
        nowX =
            Basics.min windHistoryLength (now - init)
    in
        timeScale * (nowX - (now - t))
