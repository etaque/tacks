module Game.Steps.PlayerWind where

import Models exposing (..)
import Game.Models exposing (..)
import Game.Geo exposing (..)
import Game.Grid as Grid

import List exposing (..)
import Dict exposing (Dict)


shadowSpeedImpact : Float
shadowSpeedImpact = -5 -- knots


shadowArc : Float
shadowArc = 30 -- degrees


maxWindShift = 0.5


playerWindStep : GameState -> PlayerState -> PlayerState
playerWindStep ({wind, gusts, course, opponents} as gameState) state =
  let
    shadowDirection = ensure360 (state.windOrigin + 180 + (state.windAngle / 3))

    gustTiles = gusts.gusts
      |> filter (isGustOnPlayer state)
      |> map .tiles
      |> filterMap (findGustTile state.position)

    windShadow = opponents
      |> filter (inShadow state)
      |> map (\_ -> shadowSpeedImpact)
      |> sum

    gustOrigin = sum (map .angle gustTiles)
    newOrigin = ensure360 (wind.origin + gustOrigin)

    gustSpeed = sum (map .speed gustTiles)
    speed = wind.speed + gustSpeed + windShadow

    originDelta = angleDelta state.windOrigin newOrigin
    easedOrigin =
      if abs originDelta > maxWindShift then
        ensure360 <| state.windOrigin + (maxWindShift * (if originDelta > 0 then -1 else 1))
      else
        newOrigin

  in
    { state
      | windOrigin = easedOrigin
      , windSpeed = speed
      , shadowDirection = shadowDirection
    }

isGustOnPlayer : PlayerState -> TiledGust -> Bool
isGustOnPlayer s g =
  (distance s.position g.position) < g.radius + Grid.hexRadius


findGustTile : Point -> Dict Coords GustTile -> Maybe GustTile
findGustTile p gustGrid =
  Dict.get (Grid.pointToHexCoords p) gustGrid


inShadow : PlayerState -> Opponent -> Bool
inShadow state opponent =
  (distance opponent.state.position state.position) <= windShadowLength &&
    let
      angle = angleBetween opponent.state.position state.position
      (min, max) = windShadowSector opponent.state
    in
      inSector min max angle


windShadowSector : OpponentState -> (Float,Float)
windShadowSector {shadowDirection} =
  (ensure360 (shadowDirection - shadowArc/2), ensure360 (shadowDirection + shadowArc/2))

