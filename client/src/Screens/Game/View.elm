module Screens.Game.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Game.Models exposing (GameState)

import Screens.Game.Types exposing (..)
import Screens.Game.Updates exposing (actions)

import Views.TopBar as TopBar
import Views.Utils exposing (..)
import Game.Render.All exposing (renderGame)


view : (Int, Int) -> Screen -> Html
view dims {track, gameState} =
  div [ class "show-track" ]
    [ Maybe.withDefault loading (Maybe.map (gameView dims) gameState)
    ]

loading : Html
loading =
  titleWrapper [ h1 [] [ text "loading..." ]]

gameView : (Int, Int) -> GameState -> Html
gameView (w, h) gameState =
  renderGame (w, h - TopBar.height) gameState
    |> fromElement
