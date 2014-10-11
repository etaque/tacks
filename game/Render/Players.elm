module Render.Players where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import String
import Text
import Maybe (maybe)

vmgColorAndShape : PlayerState -> (Color, Shape)
vmgColorAndShape player =
  let a = (abs player.windAngle)
      margin = 3
      s = 4
      bad = (red, rect (s*2) (s*2))
      good = (green, circle s)
      warn = (orange, polygon [(-s,-s),(s,-s),(0,s)])
  in  if a < 90 then
        if | a < player.upwindVmg - margin -> bad
           | a > player.upwindVmg + margin -> warn
           | otherwise                     -> good
      else
        if | a > player.downwindVmg + margin -> bad
           | a < player.downwindVmg - margin -> warn
           | otherwise                       -> good

renderPlayerAngles : PlayerState -> Form
renderPlayerAngles player =
  let windOriginRadians = toRadians (player.heading - player.windAngle)
      windMarker = polygon [(0,4),(-4,-4),(4,-4)]
        |> filled white
        |> rotate (windOriginRadians + pi/2)
        |> move (fromPolar (25, windOriginRadians))
        |> alpha 0.5
      windAngleText = (show (abs (round player.windAngle))) ++ "&deg;" |> baseText
        |> (if player.controlMode == "FixedAngle" then Text.line Text.Under else identity)
        |> centered |> toForm
        |> move (fromPolar (25, windOriginRadians + pi))
        |> alpha 0.5
      (vmgColor,vmgShape) = vmgColorAndShape player
      vmgIndicator = group [vmgShape |> filled vmgColor, vmgShape |> outlined (solid white)]
        |> move (fromPolar(25, windOriginRadians + pi/2))

  in  group [windMarker, windAngleText, vmgIndicator]

renderEqualityLine : Point -> Float -> Form
renderEqualityLine (x,y) windOrigin =
  let left = (fromPolar (50, toRadians (windOrigin - 90)))
      right = (fromPolar (50, toRadians (windOrigin + 90)))
  in  segment left right |> traced (dotted white) |> alpha 0.2

renderWake : [Point] -> Form
renderWake wake =
  let pairs = if (isEmpty wake) then [] else zip wake (tail wake) |> indexedMap (,)
      style = { defaultLine | color <- white, width <- 3 }
      opacityForIndex i = 0.3 - 0.3 * (toFloat i) / (toFloat (length wake))
      renderSegment (i,(a,b)) = segment a b |> traced style |> alpha (opacityForIndex i)
  in  group (map renderSegment pairs)

renderWindShadow : Float -> PlayerState -> Form
renderWindShadow shadowLength boat =
  let shadowDirection = (ensure360 (boat.windOrigin + 180 + (boat.windAngle / 3)))
      arcAngles = [-15, -10, -5, 0, 5, 10, 15]
      endPoints = map (\a -> add boat.position (fromPolar (shadowLength, toRadians (shadowDirection + a)))) arcAngles
  in  path (boat.position :: endPoints) |> filled white |> alpha 0.1

renderBoatIcon : PlayerState -> String -> Form
renderBoatIcon boat name =
  image 12 20 ("/assets/images/" ++ name ++ ".png") |> toForm
    |> rotate (toRadians (boat.heading + 90))

renderPlayer : PlayerState -> Float -> Form
renderPlayer player shadowLength =
  let hull = renderBoatIcon player "49er"
      windShadow = renderWindShadow shadowLength player
      angles = renderPlayerAngles player
      eqLine = renderEqualityLine player.position player.windOrigin
      movingPart = group [angles, eqLine, hull] |> move player.position
      wake = renderWake player.trail
  in group [wake, windShadow, movingPart]

renderOpponent : Float -> PlayerState -> Form
renderOpponent shadowLength opponent =
  let hull = renderBoatIcon opponent "49er"
        |> move opponent.position
        |> alpha 0.5
      shadow = renderWindShadow shadowLength opponent
      name = (maybe "Anonymous" identity opponent.player.handle) |> baseText |> centered |> toForm
        |> move (add opponent.position (0,-25))
        |> alpha 0.3
  in group [shadow, hull, name]

renderOpponents : Course -> [PlayerState] -> Form
renderOpponents course opponents =
  group <| map (renderOpponent course.windShadowLength) opponents

renderPlayers : GameState -> Form
renderPlayers ({playerState,opponents,course,center} as gameState) =
  let forms =
        [ renderOpponents course opponents
        , renderPlayer playerState course.windShadowLength
        ]
  in  group forms |> move (neg center)

