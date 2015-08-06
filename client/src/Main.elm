module Main where

import Task exposing (Task, andThen)
import Html exposing (Html)
import Http
import Window
import History
import Signal.Extra exposing (foldp')

import Models exposing (Player)
import AppUpdates exposing (..)
import AppTypes exposing (..)
import Inputs exposing (RaceInput)
import Outputs exposing (PlayerOutput)
import AppView
import Routes

import Debug


-- Inputs

port appSetup : AppSetup

port raceInput : Signal (Maybe RaceInput)


-- Signals

main : Signal Html
main =
  Signal.map2 AppView.view Window.dimensions appState

appState : Signal AppState
appState =
  Signal.map .appState appUpdates

appUpdates : Signal AppUpdate
appUpdates =
  let
    initialUpdate = (flip AppUpdates.update) (initialAppUpdate appSetup.player)
  in
    foldp' AppUpdates.update initialUpdate allActions

allActions : Signal AppAction
allActions =
  Signal.mergeMany
    [ Signal.constant (SetPath appSetup.path)
    , screenActions
    , actionsMailbox.signal
    , pathUpdates
    ]

pathUpdates : Signal AppAction
pathUpdates =
  Signal.map SetPath History.path

reactions : Signal (Task Http.Error AppAction)
reactions =
  Signal.map .reaction appUpdates
    |> Signal.filterMap identity (Task.succeed NoOp)


-- Runners

port reactionsRunner : Signal (Task Http.Error ())
port reactionsRunner =
  Signal.map (\t -> t `andThen` (Signal.send actionsMailbox.address)) reactions

port pathChangeRunner : Signal (Task error ())
port pathChangeRunner =
  .signal Routes.pathChangeMailbox


-- Outputs

port playerOutput : Signal (Maybe PlayerOutput)
port playerOutput =
  Signal.constant Nothing
  -- Signal.map2 extractPlayerOutput appState appInput
  --   |> Signal.filter isJust Nothing

-- port title : Signal String
-- port title = Render.Utils.gameTitle <~ gameState

port activeRaceCourse : Signal (Maybe String)
port activeRaceCourse =
  Signal.constant Nothing
  -- Signal.map getActiveRaceCourse appState
  --   |> Signal.dropRepeats

