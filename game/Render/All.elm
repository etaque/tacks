module Render.All where

import Game exposing (..)

import Render.Course exposing (renderCourse)
import Render.Players exposing (renderPlayers)
import Render.Controls exposing (renderControls)
import Render.Dashboard exposing (buildDashboard)
import Layout exposing (..)

import Graphics.Element exposing (..)

renderApp : (Int,Int) -> AppState -> Element
renderApp dims appState =
  case appState.gameState of
    Just gameState ->
      renderGame dims gameState
    Nothing ->
      empty

renderGame : (Int,Int) -> GameState -> Element
renderGame (w,h) gameState =
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
