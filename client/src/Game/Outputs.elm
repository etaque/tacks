module Game.Outputs where

import TransitRouter exposing (getRoute)

import Model exposing (..)
import Page.Game.Model exposing (..)
import Game.Models exposing (..)
import Game.Inputs exposing (..)
import Route


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
        PageAction (GameAction (GameUpdate gameInput)) ->
          Just gameInput.keyboardInput
        _ ->
          Nothing
    gameState =
      case getRoute appState of
        Route.PlayTrack _ ->
          appState.pages.game.gameState
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
  case getRoute appState of
    Route.PlayTrack _ ->
      Maybe.map (.track >> .id) appState.pages.game.liveTrack
    _ ->
      Nothing

needChatScrollDown : AppAction -> Maybe ()
needChatScrollDown action =
  case action of
    PageAction (GameAction (NewMessage _)) ->
      Just ()
    _ ->
      Nothing
