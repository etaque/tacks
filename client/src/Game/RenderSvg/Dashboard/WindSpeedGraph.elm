module Game.RenderSvg.Dashboard.WindSpeedGraph where

import Game.Models exposing (..)
import Game.Core exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)
import Game.RenderSvg.Gates exposing (..)

import String
import List exposing (..)
import Maybe as M

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)

graphWidth = 200

windCoef = 3
maxSpeed = 25

timeScale = graphWidth / windHistoryLength

render : Float -> Wind -> WindHistory -> Svg
render now wind {lastSample, samples, init} =
  let
    steps = map (\{time, speed} -> (timeX init now time, speedY speed)) samples
    currentX = timeX init now now
    currentY = speedY wind.speed

    historyPath = Svg.path
      [ pathPoints ((currentX, currentY) :: steps)
      , stroke "url(#transparentToBlack)"
      , strokeWidth "1"
      , strokeOpacity "0.8"
      , fillOpacity "0"
      ] []

    currentCircle = circle
      [ cx "0"
      , cy "0"
      , r "2"
      , fill "black"
      , transform <| translatePoint (currentX, currentY)
      ] []

    currentText = text'
      [ textAnchor "left"
      , x (toString (currentX + 8))
      , y (toString (currentY + 3))
      , fontSize "12px"
      ]
      [ text <| toString (round wind.speed) ++ "kn" ]

    xMark = segment
      [ stroke "black"
      , opacity "0.4"
      ]
      ((currentX, speedY 8), (currentX, speedY 27))
  in
    g [ opacity "0.5"
      ]
      [ yMarks
      , xMark
      , historyPath
      , currentCircle
      , currentText
      ]

yMarks : Svg
yMarks = g
  [ opacity "0.2" ]
  [ renderMark 10
  , renderMark 15
  , renderMark 20
  , renderMark 25
  ]

renderMark : Float -> Svg
renderMark speed =
  segment
    [ stroke "black"
    , strokeWidth "1"
    , strokeDasharray "3,3"
    ]
    ((0, speedY speed), (windHistoryLength * timeScale, speedY speed))

speedY : Float -> Float
speedY speed =
  (maxSpeed - speed) * windCoef

timeX : Float -> Float -> Float -> Float
timeX init now t =
  let
    nowX = Basics.min windHistoryLength (now - init)
  in
    timeScale * (nowX - (now - t))
