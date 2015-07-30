module Render.Players where

import Render.Utils exposing (..)
import Core exposing (..)
import Geo exposing (..)
import Game exposing (..)

import String
import Text exposing (..)
import List exposing (..)
import Maybe as M
import Graphics.Input exposing (clickable)
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)


vmgColorAndShape : PlayerState -> (Color, Shape)
vmgColorAndShape player =
  let a = (abs player.windAngle)
      margin = 3
      s = 4
      bad = (red, rect (s*2) (s*2))
      good = (colors.green, circle s)
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
  let
    windOriginRadians = toRadians (player.heading - player.windAngle)
    (vmgColor,vmgShape) = vmgColorAndShape player
  in
    group [vmgShape |> filled vmgColor, vmgShape |> outlined (solid white)]
      |> move (fromPolar(30, windOriginRadians + pi/2))

renderPlayerAngles : PlayerState -> Form
renderPlayerAngles player =
  let
    windOriginRadians = toRadians (player.heading - player.windAngle)
    windMarker = polygon [(0,4),(-3,-5),(3,-5)]
      |> filled white
      |> rotate (windOriginRadians + pi/2)
      |> move (fromPolar (30, windOriginRadians))
      |> alpha 0.5
    windLine = segment (0,0) (fromPolar (60, windOriginRadians))
      |> traced (solid white)
      |> alpha 0.1
    windAngleText = (toString (abs (round player.windAngle))) ++ "&deg;" |> baseText
      |> (if player.controlMode == FixedAngle then line Under else identity)
      |> centered |> toForm
      |> move (fromPolar (30, windOriginRadians + pi))
      |> alpha 0.5
  in
    group [windLine, windMarker, windAngleText]

renderEqualityLine : Point -> Float -> Form
renderEqualityLine (x,y) windOrigin =
  let
    left = (fromPolar (100, toRadians (windOrigin - 90)))
    right = (fromPolar (100, toRadians (windOrigin + 90)))
  in
    segment left right |> traced (dotted white) |> alpha 0.1

renderWake : List Point -> Form
renderWake wake =
  let
    pairs = if (isEmpty wake)
      then []
      else map2 (,) wake (tail wake |> M.withDefault []) |> indexedMap (,)
    style = { defaultLine | color <- white, width <- 3 }
    opacityForIndex i = 0.3 - 0.3 * (toFloat i) / (toFloat (length wake))
    renderSegment (i,(a,b)) = segment a b |> traced style |> alpha (opacityForIndex i)
  in
    group (map renderSegment pairs)

renderWindShadow : OpponentState -> Form
renderWindShadow {windAngle, windOrigin, position, shadowDirection} =
  let
    arcAngles = [-15, -10, -5, 0, 5, 10, 15]
    endPoints = map (\a -> add position (fromPolar (windShadowLength, toRadians (shadowDirection + a)))) arcAngles
  in
    path (position :: endPoints) |> filled white |> alpha 0.1


baseHull : Form
baseHull = image 12 20 ("/assets/images/49er.png") |> toForm

rotateHull : Float -> Form -> Form
rotateHull heading = rotate (toRadians (heading + 90))


renderPlayer : Bool -> PlayerState -> Form
renderPlayer displayWindShadow state =
  let
    hull = rotateHull state.heading baseHull
    windShadow = if displayWindShadow
      then renderWindShadow (asOpponentState state)
      else emptyForm
    angles = renderPlayerAngles state
    vmgSign = renderVmgSign state
    eqLine = renderEqualityLine state.position state.windOrigin
    movingPart = group [angles, vmgSign, eqLine, hull] |> move state.position
    wake = renderWake state.trail
  in
    group [wake, windShadow, movingPart]


renderOpponent : Opponent -> Form
renderOpponent {state,player} =
  let
    hull = rotateHull state.heading baseHull
      |> move state.position
      |> alpha 0.5
    shadow = renderWindShadow state
    name = (M.withDefault "Anonymous" player.handle)
      |> baseText |> centered |> toForm
      |> move (add state.position (0,-25))
      |> alpha 0.3
  in
    group [shadow, hull, name]

renderOpponents : Course -> List Opponent -> Form
renderOpponents course opponents =
  group <| map renderOpponent opponents


renderGhost : GhostState -> Form
renderGhost {position,heading,handle} =
  let hull = rotateHull heading baseHull
        |> move position
        |> alpha 0.5
      name = (M.withDefault "Anonymous" handle) |> baseText |> centered |> toForm
        |> move (add position (0,-25))
        |> alpha 0.3
  in group [hull, name]

renderGhosts : List GhostState -> Form
renderGhosts ghosts =
  group (map renderGhost ghosts)


renderPlayers : GameState -> Form
renderPlayers ({playerState,opponents,ghosts,course,center} as gameState) =
  let
    mainPlayer = renderPlayer True playerState
    forms =
      [ renderOpponents course opponents
      , renderGhosts ghosts
      , mainPlayer
      ]
  in
    group forms

