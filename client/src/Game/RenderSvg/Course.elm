module Game.RenderSvg.Course where

import Game.Models exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)
import Game.RenderSvg.Gates exposing (..)
import Game.RenderSvg.Tiles exposing (..)

import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)


renderCourse : GameState -> Svg
renderCourse ({playerState,course,now,wind} as gameState) =
  g [ ]
    [ lazyRenderTiles course.grid
    , renderGusts wind
    , renderDownwind playerState course now (isStarted gameState)
    , renderUpwind playerState course now
    ]

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


