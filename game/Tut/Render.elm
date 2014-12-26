module Tut.Render where

import Graphics.Collage (..)
import Graphics.Element (..)

import Render.Utils (..)
import Render.Players (..)

import Game (..)
import Tut.State (..)

renderTutPlayer : Bool -> Bool -> Bool -> PlayerState -> Form
renderTutPlayer showLines showAngles showVmg player =
  let
    hull = rotateHull player.heading baseHull
    angles = if showAngles
      then renderPlayerAngles player
      else emptyForm
    vmgSign = if showVmg
      then renderVmgSign player
      else emptyForm
    eqLine = if showLines
      then renderEqualityLine player.position player.windOrigin
      else emptyForm
    movingPart = group [angles, vmgSign, eqLine, hull] |> move player.position
    wake = renderWake player.trail
  in
    group [wake, movingPart]

render : (Int,Int) -> TutState -> Element
render (w,h) tutState =
  let
    playerForms = renderTutPlayer False False False tutState.playerState
    graphics = collage w h [group [playerForms]]
  in
    layers [graphics]
