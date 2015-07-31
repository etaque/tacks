module Render.All where

import Graphics.Element exposing (..)

import Game exposing (GameState)
-- import State exposing (AppState, RaceCourse)
-- import Inputs

import Render.Course exposing (renderCourse)
import Render.Players exposing (renderPlayers)
import Render.Controls exposing (renderControls)
import Render.Dashboard exposing (buildDashboard)
import Layout exposing (..)



-- renderIndex : Translator -> AppState -> (Int,Int) -> Element
-- renderIndex t appState (w,h) =
--   LiveCenterViews.indexView t appState.liveCenterState
--     |> Html.toElement w h

-- renderLeaderboard : Translator -> AppState -> RaceCourse -> Element
-- renderLeaderboard t appState raceCourse =
--   empty

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
