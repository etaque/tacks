module Render.Players where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import Inputs (watchedPlayer)

import String
import Text
import Maybe (maybe)
import Graphics.Input (clickable)

vmgColorAndShape : PlayerState -> (Color, Shape)
vmgColorAndShape player =
  let a = (abs player.windAngle)
      margin = 3
      s = 4
      bad = (red, rect (s*2) (s*2))
      good = (green, circle s)
      warn = (orange, polygon [(-s,-s),(s,-s),(0,s)])
  in  if a < 90 then
        if | a < player.upwindVmg.angle - margin -> bad
           | a > player.upwindVmg.angle + margin -> warn
           | otherwise                           -> good
      else
        if | a > player.downwindVmg.angle + margin -> bad
           | a < player.downwindVmg.angle - margin -> warn
           | otherwise                             -> good

renderVmgSign : PlayerState -> Form
renderVmgSign player =
  let windOriginRadians = toRadians (player.heading - player.windAngle)
      (vmgColor,vmgShape) = vmgColorAndShape player
  in  group [vmgShape |> filled vmgColor, vmgShape |> outlined (solid white)]
        |> move (fromPolar(30, windOriginRadians + pi/2))

renderPlayerAngles : PlayerState -> Form
renderPlayerAngles player =
  let windOriginRadians = toRadians (player.heading - player.windAngle)
      windMarker = polygon [(0,4),(-3,-5),(3,-5)]
        |> filled white
        |> rotate (windOriginRadians + pi/2)
        |> move (fromPolar (30, windOriginRadians))
        |> alpha 0.5
      windLine = segment (0,0) (fromPolar (60, windOriginRadians))
        |> traced (solid white)
        |> alpha 0.1
      windAngleText = (show (abs (round player.windAngle))) ++ "&deg;" |> baseText
        |> (if player.controlMode == "FixedAngle" then Text.line Text.Under else identity)
        |> centered |> toForm
        |> move (fromPolar (30, windOriginRadians + pi))
        |> alpha 0.5

  in  group [windLine, windMarker, windAngleText]

renderEqualityLine : Point -> Float -> Form
renderEqualityLine (x,y) windOrigin =
  let left = (fromPolar (100, toRadians (windOrigin - 90)))
      right = (fromPolar (100, toRadians (windOrigin + 90)))
  in  segment left right |> traced (dotted white) |> alpha 0.1

renderWake : [Point] -> Form
renderWake wake =
  let pairs = if (isEmpty wake) then [] else zip wake (tail wake) |> indexedMap (,)
      style = { defaultLine | color <- white, width <- 3 }
      opacityForIndex i = 0.3 - 0.3 * (toFloat i) / (toFloat (length wake))
      renderSegment (i,(a,b)) = segment a b |> traced style |> alpha (opacityForIndex i)
  in  group (map renderSegment pairs)

renderWindShadow : Float -> PlayerState -> Form
renderWindShadow shadowLength {windAngle, windOrigin, position, shadowDirection} =
  let arcAngles = [-15, -10, -5, 0, 5, 10, 15]
      endPoints = map (\a -> add position (fromPolar (shadowLength, toRadians (shadowDirection + a)))) arcAngles
  in  path (position :: endPoints) |> filled white |> alpha 0.1

renderBoatIcon : Float -> String -> Form
renderBoatIcon heading name =
  image 12 20 ("/assets/images/" ++ name ++ ".png")
    |> toForm
    |> rotate (toRadians (heading + 90))

renderPlayer : GameMode -> Float -> PlayerState -> Form
renderPlayer gameMode shadowLength player =
  let hull = renderBoatIcon player.heading "49er"
      windShadow = case gameMode of
        Race -> renderWindShadow shadowLength player
        TimeTrial -> emptyForm
      angles = renderPlayerAngles player
      vmgSign = renderVmgSign player
      eqLine = renderEqualityLine player.position player.windOrigin
      movingPart = group [angles, vmgSign, eqLine, hull] |> move player.position
      wake = renderWake player.trail
  in group [wake, windShadow, movingPart]

renderOpponent : Float -> PlayerState -> Form
renderOpponent shadowLength opponent =
  let hull = renderBoatIcon opponent.heading "49er"
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

renderGhost : GhostState -> Form
renderGhost {position,heading,handle} =
  let hull = renderBoatIcon heading "49er"
        |> move position
        |> alpha 0.5
      name = (maybe "Anonymous" identity handle) |> baseText |> centered |> toForm
        |> move (add position (0,-25))
        |> alpha 0.3
  in group [hull, name]

renderPlayers : GameState -> Form
renderPlayers ({playerState,opponents,ghosts,course,center,watchMode,gameMode} as gameState) =
  let mainPlayer = case playerState of
        Just ps ->
          maybe emptyForm (renderPlayer gameMode course.windShadowLength) playerState
        Nothing -> case watchMode of
          Watching playerId -> maybe emptyForm (renderPlayer gameMode course.windShadowLength) (findOpponent opponents playerId)
          NotWatching -> emptyForm
      filteredOpponents = case watchMode of
        Watching playerId -> filter (\o -> o.player.id /= playerId) opponents
        NotWatching -> opponents
      forms =
        [ renderOpponents course filteredOpponents
        , map renderGhost ghosts |> group
        , mainPlayer
        ]
  in  group forms |> move (neg center)

