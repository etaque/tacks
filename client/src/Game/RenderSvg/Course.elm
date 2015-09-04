module Game.RenderSvg.Course where

import Game.Models exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)
import Game.RenderSvg.Gates exposing (..)

import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)


renderCourse : GameState -> Svg
renderCourse ({playerState,course,now,wind} as gameState) =
    g [ ]
      [ renderBounds course.area
      -- , renderLaylines wind course playerState
      , renderIslands course
      , renderDownwind playerState course now (isStarted gameState)
      , renderUpwind playerState course now
      , renderGusts wind
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
      , strokeWidth "2"
      , fill "url(#seaPattern)" -- (colorToSvg colors.seaBlue)
      , transform (translate -(w/2) (top - h))
      ] [ ]

renderIslands : Course -> Svg
renderIslands course =
  g [] (List.map renderIsland course.islands)

renderIsland : Island -> Svg
renderIsland {location,radius} =
  circle
    [ r (toString radius)
    , fill (colorToSvg colors.sand)
    , transform (translatePoint location)
    ] []

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


