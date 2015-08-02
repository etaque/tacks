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
  Maybe.map
    (makePlayerOutput (Maybe.map .keyboardInput appInput.gameInput))
    appState.gameState

makePlayerOutput : Maybe KeyboardInput -> Game.GameState -> PlayerOutput
makePlayerOutput keyboardInput gameState =
  { state = Game.asOpponentState gameState.playerState
  , input = Maybe.withDefault emptyKeyboardInput keyboardInput
  , localTime = gameState.localTime
  }

getActiveRaceCourse : State.AppState -> Maybe String
getActiveRaceCourse appState =
  case appState.screen of
    State.Play raceCourse ->
      Just raceCourse.id
    _ ->
      Nothing
