module Game.Steps.Wind where

import Game.Models exposing (..)
import Game.Geo exposing (..)

import List as L

type alias GustEffect =
  { origin: Float
  , speed: Float
  , factor: Float
  }


shadowImpact : Float
shadowImpact = -5 -- knots

shadowArc : Float
shadowArc = 30 -- degrees


windStep : GameState -> PlayerState -> PlayerState
windStep ({wind,course,opponents} as gameState) state =
  let
    shadowDirection = ensure360 (state.windOrigin + 180 + (state.windAngle / 3))

    gustsOnPlayer = L.filter (\g -> (distance state.position g.position) < g.radius) wind.gusts
    gustsEffects = L.map (gustEffect state wind) gustsOnPlayer

    windShadow =
      L.filter (isShadowedBy state) opponents
      |> L.map (\_ -> shadowImpact)
      |> L.sum

    origin =
      if L.isEmpty gustsEffects then
        wind.origin
      else
        let totalEffect = L.map (\g -> g.origin * g.factor) gustsEffects |> L.sum
        in  ensure360 (wind.origin + totalEffect)

    speed = wind.speed + (L.map (\g -> g.speed * g.factor) gustsEffects |> L.sum) + windShadow
  in
    { state
      | windOrigin <- origin
      , windSpeed <- speed
      , shadowDirection <- shadowDirection
    }


gustEffect : PlayerState -> Wind -> Gust -> GustEffect
gustEffect state wind gust =
  let
    d = distance state.position gust.position
    fromEdge = gust.radius - d
    factor = min (fromEdge / (gust.radius * 0.2)) 1

    originEffect = angleDelta gust.angle wind.origin
    speedEffect = gust.speed
  in
    { origin = originEffect
    , speed = speedEffect
    , factor = factor
    }


isShadowedBy : PlayerState -> Opponent -> Bool
isShadowedBy state opponent =
  (distance opponent.state.position state.position) <= windShadowLength &&
    let
      angle = angleBetween opponent.state.position state.position
      (min, max) = windShadowSector opponent.state
    in
      inSector min max angle


windShadowSector : OpponentState -> (Float,Float)
windShadowSector {shadowDirection} =
  (ensure360 (shadowDirection - shadowArc/2), ensure360 (shadowDirection + shadowArc/2))
