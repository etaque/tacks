module LiveCenter.Views where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import LiveCenter.State exposing (..)
import LiveCenter.Update exposing (..)
import Messages exposing (Translator)


localActions : Signal.Mailbox Action
localActions = Signal.mailbox NoOp

view : Translator -> State -> Html
view t state =
  div [] []
