module LiveCenter.Main where

import Json.Decode as Json
import Html exposing (Html)
import Task exposing (Task)
import Http
import Time exposing (every, second)

import Messages

import LiveCenter.State exposing (..)
import LiveCenter.Views exposing (mainView)
import LiveCenter.Update as U exposing (Action, updateState, actionsMailbox)


port messagesStore : Json.Value

port serverUpdateRunner : Signal (Task Http.Error ())
port serverUpdateRunner =
  Signal.map (\_ -> U.runServerUpdate) (every second)


main : Signal Html
main = Signal.map (mainView translator) state

translator : Messages.Translator
translator = Messages.translator (Messages.fromJson messagesStore)

state : Signal State
state = Signal.foldp updateState emptyState updates

updates : Signal Action
updates =
  actionsMailbox.signal

