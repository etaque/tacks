module Screens.Game.ChatView where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Game.Models exposing (GameState)

import Screens.Game.Types exposing (..)
import Screens.Game.Updates exposing (actions)

import Screens.Utils exposing (..)


chatBlock : Screen -> Html
chatBlock {messages, messageField} =
  div [ class "aside-module module-chat"]
    [ div [ class "messages" ] [ messagesList messages ]
    , chatField messageField
    ]


messagesList : List Message -> Html
messagesList messages =
  ul [ class "list-unstyled" ] (List.map messageItem (List.reverse messages))


messageItem : Message -> Html
messageItem {player, content, time} =
  li [ ]
    [ span [ class "message-handle" ] [ text <| playerHandle player ]
    , span [ class "message-content" ] [ text content ]
    ]


chatField : String -> Html
chatField field =
  textInput
    [ value field
    , onInput actions.address UpdateMessageField
    , onEnter actions.address SubmitMessage
    , onFocus actions.address EnterChat
    , onBlur actions.address LeaveChat
    ]
