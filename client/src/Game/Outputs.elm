module Game.Outputs where

import TransitRouter exposing (getRoute)

import Model exposing (..)
import Page.Game.Model as GamePage
import Game.Models exposing (..)
import Game.Inputs exposing (..)
import Route


type alias PlayerOutput =
  { state: OpponentState
  , input: KeyboardInput
  , localTime: Float
  }

extractPlayerOutput : Model -> Action -> Maybe PlayerOutput
extractPlayerOutput model action =
  let
    keyboardInput =
      case action of
        PageAction (GameAction (GamePage.GameUpdate gameInput)) ->
          Just gameInput.keyboardInput
        _ ->
          Nothing
    gameState =
      case getRoute model of
        Route.PlayTrack _ ->
          model.pages.game.gameState
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

getActiveTrack : Model -> Maybe String
getActiveTrack model =
  case getRoute model of
    Route.PlayTrack _ ->
      Maybe.map (.track >> .id) model.pages.game.liveTrack
    _ ->
      Nothing

needChatScrollDown : Action -> Maybe ()
needChatScrollDown action =
  case action of
    PageAction (GameAction (GamePage.NewMessage _)) ->
      Just ()
    _ ->
      Nothing
