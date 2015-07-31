module Views.Main where

import Graphics.Element exposing (empty)
import Html exposing (..)
import Html.Attributes exposing (..)

import State exposing (..)
import Messages exposing (Translator)

import Views.TopBar as TopBar
import Views.Home as Home
import Views.ShowRaceCourse as ShowRaceCourse

import Render.All exposing (renderGame)

mainView : Translator -> (Int,Int) -> AppState -> Html
mainView t (w,h) appState =
  case appState.screen of

    Home ->
      layout t appState (Home.view t appState.liveCenterState)

    Show raceCourseStatus ->
      layout t appState (ShowRaceCourse.view t appState.liveCenterState raceCourseStatus)

    Play raceCourse ->
      let
        gameView = case appState.gameState of
          Just gameState ->
            renderGame (w, h - TopBar.height) gameState
          Nothing ->
            -- TODO loading
            empty
      in
        layout t appState (fromElement gameView)


layout : Translator -> AppState -> Html -> Html
layout t appState content =
  div [ class "global-wrapper" ]
    [ TopBar.view t appState
    , content
    ]

