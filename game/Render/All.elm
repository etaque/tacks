module Render.All where

import Game (..)

import Render.Utils (colors, emptyForm)
import Render.Course (renderCourse)
import Render.Players (renderPlayers)
import Render.Controls (renderControls)
import Render.Dashboard (buildDashboard)
import Layout (..)

import Graphics.Collage (..)
import Graphics.Element (..)
import Maybe as M

render : (Int,Int) -> GameState -> Element
render (w,h) gameState =
  let
    courseForm = renderCourse gameState
    playersForm = renderPlayers gameState
    controlsForm = M.map (renderControls gameState (w,h)) gameState.playerState
      |> M.withDefault emptyForm

    layout =
      { dashboard = buildDashboard gameState (w,h)
      , relStack  = [ courseForm, playersForm ]
      , absStack  = [ controlsForm ]
      }
  in
    assembleLayout (w,h) gameState.center layout