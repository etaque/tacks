module Game.Outputs where

import AppTypes exposing (..)
import Models exposing (..)
import Screens.Game.Types exposing (..)
import Game.Models exposing (..)
import Game.Inputs exposing (..)

import Debug

type alias PlayerOutput =
  { state: OpponentState
  , input: KeyboardInput
  , localTime: Float
  }

extractPlayerOutput : AppState -> AppAction -> Maybe PlayerOutput
extractPlayerOutput appState action =
  let
    keyboardInput =
      case action of
        GameAction (GameUpdate gameInput) ->
          Just gameInput.keyboardInput
        _ ->
          Nothing
    gameState =
      case appState.screen of
        GameScreen screen ->
          screen.gameState
        _ ->
          Nothing
  in
    Maybe.map (makePlayerOutput keyboardInput) gameState

makePlayerOutput : Maybe KeyboardInput -> GameState -> PlayerOutput
makePlayerOutput keyboardInput gameState =
  let
    realKeyboardInput =
      if gameState.chatting
        then emptyKeyboardInput
        else Maybe.withDefault emptyKeyboardInput keyboardInput
  in
    { state = asOpponentState gameState.playerState
    , input = realKeyboardInput
    , localTime = gameState.localTime
    }

getActiveTrack : AppState -> Maybe String
getActiveTrack appState =
  case appState.screen of
    GameScreen screen ->
      Maybe.map .id screen.track
    _ ->
      Nothing
