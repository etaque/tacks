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

reactions : Signal (Task Http.Error ())
reactions =
  Signal.map .reaction appUpdates
    |> Signal.filterMap identity (Task.succeed ())

requests : Signal (Task error AppAction)
requests =
  Signal.map .request appUpdates
    |> Signal.filterMap identity NoOp
    |> Signal.map Task.succeed


-- Runners

port reactionsRunner : Signal (Task Http.Error Task.ThreadID)
port reactionsRunner =
  Signal.map Task.spawn reactions

port requestsRunner : Signal (Task error Task.ThreadID)
port requestsRunner =
  Signal.map (\t -> Task.spawn (t `andThen` (Signal.send actionsMailbox.address))) requests

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

port activeTrack : Signal (Maybe String)
port activeTrack =
  Signal.constant Nothing
  -- Signal.map getActiveTrack appState
  --   |> Signal.dropRepeats
