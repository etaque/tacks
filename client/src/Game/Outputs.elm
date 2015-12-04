module Game.Outputs where

import AppTypes exposing (..)
import Screens.Game.Types exposing (..)
import Game.Models exposing (..)
import Game.Inputs exposing (..)
import Routes


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
        ScreenAction (GameAction (GameUpdate gameInput)) ->
          Just gameInput.keyboardInput
        _ ->
          Nothing
    gameState =
      case appState.route of
        Just (Routes.PlayTrack _) ->
          appState.screens.game.gameState
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
    , localTime = gameState.timers.localTime
    }

getActiveTrack : AppState -> Maybe String
getActiveTrack appState =
  case appState.route of
    Just (Routes.PlayTrack _) ->
      Maybe.map (.track >> .id) appState.screens.game.liveTrack
    _ ->
      Nothing

needChatScrollDown : AppAction -> Maybe ()
needChatScrollDown action =
  case action of
    ScreenAction (GameAction (NewMessage _)) ->
      Just ()
    _ ->
      Nothing
