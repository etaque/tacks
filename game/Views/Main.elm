module Views.Main where

import Graphics.Element exposing (..)
import Graphics.Input exposing (..)

import State exposing (..)
import Messages exposing (Translator)

import Views.TopBar as TopBar
import Views.Home as Home
import Views.ShowRaceCourse as ShowRaceCourse

import Render.All exposing (renderGame)

mainView : Translator -> (Int,Int) -> AppState -> Element
mainView t (w,h) appState =
  case appState.screen of

    Home ->
      flow down
        [ TopBar.view t w appState
        , Home.view t w appState
        ]

    Show raceCourseStatus ->
      flow down
        [ TopBar.view t w appState
        , ShowRaceCourse.view t w appState raceCourseStatus
        ]

    Play raceCourse ->
      let
        gameView = case appState.gameState of
          Just gameState ->
            renderGame (w, h - TopBar.height) gameState
          Nothing ->
            -- TODO loading
            empty
      in
        flow down
          [ TopBar.view t w appState
          , gameView
          ]


-- withTopBar : Translator -> (Int,Int) -> AppState -> Element -> Element
-- withTopBar t (w,h) appState element =
--   flow down
--     [ TopBar.view t w appState
--     , element
-- ]

