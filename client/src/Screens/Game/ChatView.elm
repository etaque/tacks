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


chatBlock : Int -> Screen -> Html
chatBlock h {messages, messageField} =
  let
    messagesDiv =
      if List.isEmpty messages then
        div [] []
      else
        div [ class "messages", style [ ("maxHeight", toString (h // 3 * 2) ++ "px") ] ] [ messagesList messages ]
  in
    div [ class "module-chat" ]
      [ h3 [ ] [ text "Chat" ]
      , messagesDiv
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
    , placeholder "type in there..."
    , onInput actions.address UpdateMessageField
    , onEnter actions.address SubmitMessage
    , onFocus actions.address EnterChat
    , onBlur actions.address LeaveChat
    ]
