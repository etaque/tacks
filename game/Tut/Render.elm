module Tut.Render where

import Graphics.Collage (..)
import Graphics.Element (..)
import Color (white,black)
import List (..)

import Render.Utils (..)
import Render.Players (..)

import Game (..)
import Tut.State (..)
import Tut.Dashboard (renderDashboard)

import Debug

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

windArrowPath : Path
windArrowPath =
  path
    [ (0,0)
    , (10,10)
    , (5,10)
    , (5,25)
    , (-5,25)
    , (-5,10)
    , (-10,10)
    ]

renderHelpers : (Int,Int) -> TutState -> Form
renderHelpers (w,h) tutState =
  let
    (w',h') = (toFloat w, toFloat h)
    i = (round tutState.stepTime) % 2000 |> toFloat
    a = i / 2000 * 0.5
    y = h' / 4 - (i / 50)
    windArrow = windArrowPath
      |> filled white
      |> scale 2
    arrowForms = map (\x -> move (x,y) windArrow) [-w' / 6, 0, w' / 6]
  in
    group arrowForms |> alpha a

render : (Int,Int) -> TutState -> Element
render (w,h) tutState =
  let
    playerForms = renderTutPlayer False False False tutState.playerState
    helpers = renderHelpers (w,h) tutState
    graphics = collage w h [group [playerForms, helpers]]
    dashboard = renderDashboard tutState (w,h)
  in
    layers [graphics, dashboard]
