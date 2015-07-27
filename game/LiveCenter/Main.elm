module LiveCenter.Main where

import Json.Decode as Json

import Html exposing (Html)

import Messages

import LiveCenter.State exposing (..)
import LiveCenter.Views exposing (mainView, localActions)
import LiveCenter.Update as U exposing (Action, updateState)


-- port serverInput : Signal U.ServerInput
port messagesStore : Json.Value


main : Signal Html
main = Signal.map (mainView translator) state

translator : Messages.Translator
translator = Messages.translator (Messages.fromJson messagesStore)

state : Signal State
state = Signal.foldp updateState emptyState updates

updates : Signal Action
updates = Signal.mergeMany
  [ -- Signal.map U.ServerUpdate serverInput
   localActions.signal
  ]


