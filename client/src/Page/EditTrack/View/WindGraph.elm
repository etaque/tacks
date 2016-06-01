module Page.EditTrack.View.WindGraph exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Constants
import Model.Shared exposing (WindGenerator, Course)
import Page.EditTrack.Model exposing (..)
import Game.Render.SvgUtils as SvgUtils


graphHeight =
  400


graphWidth =
  Constants.sidebarWidth - 48


originSpan =
  40


render : Editor -> Svg msg
render { course, windSimDuration } =
  let
    duration =
      case windSimDuration of
        TenMin ->
          10 * 60

        OneHour ->
          60 * 60

    points =
      [0..duration]
        |> List.map (\t -> ( t, generate course.windGenerator (t * 1000) ))
        |> List.map (getPoint duration)

    curve =
      Svg.path
        [ SvgUtils.pathPoints points
        , class "curve"
        ]
        []

    originAxis =
      SvgUtils.segment
        [ class "origin-axis" ]
        ( ( graphWidth / 2, 0 ), ( graphWidth / 2, graphHeight ) )

    timeIntervals =
      10

    timeIntervalsDuration =
      duration / timeIntervals

    timeMarkCoords i =
      let
        h =
          i * timeIntervalsDuration * graphHeight / duration
      in
        ( ( 0, h ), ( graphWidth, h ) )

    timeMarks =
      [0..timeIntervals]
        |> List.map timeMarkCoords
        |> List.map (SvgUtils.segment [])
  in
    svg
      [ width (toString graphWidth)
      , height (toString graphHeight)
      ]
      [ originAxis
      -- , g [ class "time-marks" ] timeMarks
      , text'
          [ x "4"
          , y "16"
          ]
          [ text <| "-" ++ toString (originSpan / 2) ++ "°" ]
      , text'
          [ x (toString (graphWidth - 4))
          , y "16"
          , textAnchor "end"
          ]
          [ text <| "+" ++ toString (originSpan / 2) ++ "°" ]
      , curve
      ]


getPoint : Float -> ( Float, Float ) -> ( Float, Float )
getPoint duration ( time, origin ) =
  let
    x =
      (origin + originSpan / 2) * graphWidth / originSpan

    y =
      time * graphHeight / duration
  in
    ( x, y )


generate : WindGenerator -> Float -> Float
generate gen clock =
  cos (clock * 0.0005 / toFloat gen.wavelength1)
    * (toFloat gen.amplitude1)
    + cos (clock * 0.0005 / toFloat gen.wavelength2)
    * (toFloat gen.amplitude2)
