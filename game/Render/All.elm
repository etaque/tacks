module Render.All where

import Game exposing (..)

import Render.Course exposing (renderCourse)
import Render.Players exposing (renderPlayers)
import Render.Controls exposing (renderControls)
import Render.Dashboard exposing (buildDashboard)
import Layout exposing (..)

import Graphics.Element exposing (..)

render : (Int,Int) -> GameState -> Element
render (w,h) gameState =
  let
    courseForm = renderCourse gameState
    playersForm = renderPlayers gameState
    controlsForm = renderControls gameState (w,h)

    layout =
      { dashboard = buildDashboard gameState (w,h)
      , relStack  = [ courseForm, playersForm ]
      , absStack  = [ controlsForm ]
      }
  in
    assembleLayout (w,h) gameState.center layout
