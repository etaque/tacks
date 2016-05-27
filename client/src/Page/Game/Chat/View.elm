module Page.Game.Chat.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Page.Game.Chat.Model exposing (..)
import View.Utils exposing (..)


view : Int -> Model -> Html Msg
view h {messages, field} =
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
      , fieldView field
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


fieldView : String -> Html Msg
fieldView field =
  textInput
    [ id fieldId
    , value field
    , placeholder "type in there..."
    , onInput UpdateField
    -- , onEnter Submit
    -- , onEscape (Exit True)
    , onFocus (Enter False)
    , onBlur (Exit False)
    ]
