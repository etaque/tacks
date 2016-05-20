module Page.Game.View.Chat exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Page.Game.Model exposing (..)
import View.Utils exposing (..)


view : Int -> Model -> Html Msg
view h {messages, messageField} =
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


messagesList : List Message -> Html Msg
messagesList messages =
  ul [ class "list-unstyled" ] (List.map messageItem (List.reverse messages))


messageItem : Message -> Html Msg
messageItem {player, content, time} =
  li [ ]
    [ span [ class "message-handle" ] [ text <| playerHandle player ]
    , span [ class "message-content" ] [ text content ]
    ]


chatField : String -> Html Msg
chatField field =
  textInput
    [ value field
    , placeholder "type in there..."
    , onInput UpdateMessageField
    , onEnter SubmitMessage
    , onFocus EnterChat
    , onBlur LeaveChat
    ]
