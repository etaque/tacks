module Game.Render.Course where

import Game.Render.Utils exposing (..)
import Game.Render.Gates exposing (..)
import Game.Models exposing (..)
import Models exposing (..)

import Maybe as M
import List exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (white,black)
import Time exposing (Time)


renderCourse : GameState -> Form
renderCourse ({playerState,course,now,wind} as gameState) =
  let
    forms =
      [ renderBounds course.area
      , renderLaylines wind course playerState
      -- , renderIslands course
      , renderDownwind playerState course now (isStarted gameState)
      , renderUpwind playerState course now
      , renderGusts wind
      ]
  in
    group forms

renderBounds : RaceArea -> Form
renderBounds area =
  let
    (w,h) = areaDims area
    (cw,ch) = areaCenters area
    fill = rect w h
      |> filled colors.seaBlue
    stroke = rect w h
      |> outlined { defaultLine | width <- 2, color <- white, cap <- Round, join <- Smooth }
      |> alpha 0.8
  in
    group [fill, stroke] |> move (cw, ch)


renderLaylines : Wind -> Course -> PlayerState -> Form
renderLaylines wind course playerState =
  case playerState.nextGate of
    Just UpwindGate   -> renderGateLaylines playerState.upwindVmg wind.origin course.area course.upwind
    Just DownwindGate -> renderGateLaylines playerState.downwindVmg wind.origin course.area course.downwind
    _                 -> emptyForm

-- renderIslands : Course -> Form
-- renderIslands course =
--   let renderIsland {location,radius} = circle radius |> filled colors.sand |> move location
--   in  group <| map renderIsland course.islands

renderDownwind : PlayerState -> Course -> Float -> Bool -> Form
renderDownwind playerState course now started =
  let
    isFirstGate = isEmpty playerState.crossedGates
    isLastGate = length playerState.crossedGates == course.laps * 2
    isNext = playerState.nextGate == Just DownwindGate
  in
    if | isFirstGate -> renderStartLine course.downwind started now
       | isLastGate  -> renderFinishLine course.downwind now
       | otherwise   -> renderGate course.downwind now isNext Downwind


renderUpwind : PlayerState -> Course -> Float -> Form
renderUpwind playerState course now =
  let
    isNext = playerState.nextGate == Just UpwindGate
  in
    renderGate course.upwind now isNext Upwind


renderGust : Wind -> Gust -> Form
renderGust wind gust =
  let a = 0.3 * (abs gust.speed) / 10
      color = if gust.speed > 0 then black else white
  in  circle gust.radius |> filled color |> alpha a |> move gust.position


renderGusts : Wind -> Form
renderGusts wind =
  group <| map (renderGust wind) wind.gusts


