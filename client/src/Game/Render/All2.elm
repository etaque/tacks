module Game.Render.All2 where

import Game.Models exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)

import String
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)
import Color exposing (Color)

import Debug exposing (..)



renderSvg : (Int, Int) -> GameState -> Html
renderSvg (w, h) gameState =
  let
    cx = (toFloat w) / 2 - (fst gameState.center)
    cy = (toFloat h) / 2 - (toFloat h) - (snd gameState.center)
  in
    svg
      [ width (toString w)
      , height (toString h)
      , version "1.1"
      ]
      [ g [ transform ("scale(1,-1)" ++ (translate cx cy)) ]
        [ renderBounds gameState.course.area
        , renderGusts gameState.wind
        , renderIslands gameState.course
        , g [ transform (translatePoint gameState.playerState.position) ]
              [ lazy renderPlayerHull gameState.playerState.heading ]
        , circle [ r "10" ] [ ]
        ]
      ]

renderBounds : RaceArea -> Svg
renderBounds area =
  let
    (w,h) = areaDims area
    (cw,ch) = areaCenters area
    top = areaTop area
  in
    rect
      [ width (toString w)
      , height (toString h)
      , stroke "white"
      , fill (colorToSvg colors.seaBlue)
      , transform (translate -(w/2) (top - h))
      ] [ ]


renderIslands : Course -> Svg
renderIslands course =
  let
    renderIsland {location,radius} =
      circle
        [ r (toString radius)
        , fill (colorToSvg colors.sand)
        , transform (translatePoint location)
        ] []
  in
    g [] (List.map renderIsland course.islands)

renderGusts : Wind -> Svg
renderGusts wind =
  g [] (List.map renderGust wind.gusts)

renderGust : Gust -> Svg
renderGust gust =
  let
    a = 0.3 * (abs gust.speed) / 10
    color = if gust.speed > 0 then "black" else "white"
  in
    circle
      [ r (toString gust.radius)
      , fill color
      , fillOpacity (toString a)
      , transform (translatePoint gust.position)
      ] []

renderPlayerHull : Float -> Svg
renderPlayerHull heading =
  g
    [ transform (hullRotation heading) ]
    [ hull ]


hullRotation : Float -> String
hullRotation heading =
  let
    r = (-heading)
  in
    "rotate(" ++ toString r ++ ")"

hull : Svg
hull =
  rect
    [ width "12"
    , height "20"
    , x "-6"
    , y "-10"
    , fill "white"
    ] []
