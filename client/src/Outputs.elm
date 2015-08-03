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
  let
    keyboardInput =
      case appInput.action of
        GameUpdate gameInput ->
          Just gameInput.keyboardInput
        _ ->
          Nothing
  in
    Maybe.map (makePlayerOutput keyboardInput) appState.gameState

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
