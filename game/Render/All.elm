module Render.All where

import Game (..)

import Render.Utils (colors)
import Render.Course (renderCourse)
import Render.Players (renderPlayers)
import Render.Controls (renderControls)
import Render.Dashboard (renderDashboard)

renderAll : (Int,Int) -> GameState -> Element
renderAll (w,h) gameState =
  let courseForm = renderCourse gameState
      playersForms = renderPlayers gameState
      controlsForm = renderControls gameState (w,h)
      dashboard = renderDashboard gameState (w,h)
      graphics = collage w h [group [courseForm, playersForms, controlsForm]]
  in  layers [graphics, dashboard]
