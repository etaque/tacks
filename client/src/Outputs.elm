module Outputs where

import Game exposing (..)
import Models exposing (..)
import Inputs exposing (..)


type alias PlayerOutput =
  { state: OpponentState
  , input: KeyboardInput
  , localTime: Float
  }

-- extractPlayerOutput : State.AppState -> AppInput -> Maybe PlayerOutput
-- extractPlayerOutput appState appInput =
--   let
--     keyboardInput =
--       case appInput.action of
--         GameUpdate gameInput ->
--           Just gameInput.keyboardInput
--         _ ->
--           Nothing
--   in
--     Maybe.map (makePlayerOutput keyboardInput) appState.gameState

-- makePlayerOutput : Maybe KeyboardInput -> GameState -> PlayerOutput
-- makePlayerOutput keyboardInput gameState =
--   { state = asOpponentState gameState.playerState
--   , input = Maybe.withDefault emptyKeyboardInput keyboardInput
--   , localTime = gameState.localTime
--   }

-- getActiveRaceCourse : State.AppState -> Maybe String
-- getActiveRaceCourse appState =
--   case appState.screen of
--     State.Play raceCourse ->
--       Just raceCourse.id
--     _ ->
--       Nothing
