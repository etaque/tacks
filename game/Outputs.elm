module Outputs where

import Game
import State
import Inputs exposing (..)


type alias PlayerOutput =
  { state: Game.OpponentState
  , input: KeyboardInput
  , localTime: Float
  }

extractPlayerOutput : State.AppState -> AppInput -> Maybe PlayerOutput
extractPlayerOutput appState appInput =
  case (appState.gameState, appInput.gameInput) of
    (Just gameState, Just gameInput) ->
      Just (makePlayerOutput gameInput gameState)
    _ ->
      Nothing

makePlayerOutput : GameInput -> Game.GameState -> PlayerOutput
makePlayerOutput gameInput gameState =
  { state = Game.asOpponentState gameState.playerState
  , input = gameInput.keyboardInput
  , localTime = gameState.localTime
  }

getActiveRaceCourse : State.AppState -> Maybe String
getActiveRaceCourse appState =
  case appState.screen of
    State.Play raceCourse ->
      Just raceCourse.id
    _ ->
      Nothing
