module Main where

import Task exposing (Task)
import Html exposing (Html)
import Http
import Window

import Models exposing (Player)
import AppUpdates exposing (..)
import AppTypes exposing (..)
import AppView


port currentPlayer : Player

port reactionsRunner : Signal (Task Http.Error ())
port reactionsRunner =
  Signal.map (Task.map (Signal.send actionsMailbox.address)) reactions


main : Signal Html
main =
  Signal.map2 AppView.view Window.dimensions appState


appState : Signal AppState
appState =
  Signal.map .appState appUpdates


appUpdates : Signal AppUpdate
appUpdates =
  Signal.foldp AppUpdates.update (initialAppUpdate currentPlayer) allActions


allActions : Signal AppAction
allActions =
  Signal.mergeMany
    [ screenActions
    , actionsMailbox.signal
    ]


reactions : Signal (Task Http.Error AppAction)
reactions =
  Signal.map .reaction appUpdates
    |> Signal.filterMap identity NoOp
