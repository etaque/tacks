module Render.All where

import Game (..)

import Render.Utils (colors, emptyForm)
import Render.Course (renderCourse)
import Render.Players (renderPlayers)
import Render.Controls (renderControls)
import Render.Dashboard (renderDashboard)

import Graphics.Collage (..)
import Graphics.Element (..)
import Maybe as M

renderAll : (Int,Int) -> GameState -> Element
renderAll (w,h) gameState =
  let courseForm = renderCourse gameState
      playersForms = renderPlayers gameState
      controlsForm = M.map (renderControls gameState (w,h)) gameState.playerState
        |> M.withDefault emptyForm
      dashboard = renderDashboard gameState (w,h)
      graphics = collage w h [group [courseForm, playersForms, controlsForm]]
  in  layers [graphics, dashboard]
