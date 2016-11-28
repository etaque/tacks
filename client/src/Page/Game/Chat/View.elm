module Page.Game.Chat.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Page.Game.Chat.Model exposing (..)
import View.Utils exposing (..)


messages : Model -> Html Msg
messages model =
    div
        [ class "chat-messages"
        , id messagesId
        ]
        [ ul
            [ class "list-unstyled" ]
            (List.map messageItem (List.reverse model.messages))
        ]


messageItem : Message -> Html Msg
messageItem { player, content, time } =
    li
        []
        [ span
            [ class "handle" ]
            [ text (playerHandle player) ]
        , span
            [ class "content" ]
            [ text content ]
        ]


inputField : Model -> Html Msg
inputField { field } =
    div
        [ class "chat-input" ]
        [ input
            [ type_ "text"
            , id fieldId
            , value field
            , placeholder "press Enter to chat"
            , onInput UpdateField
            , onFocus (Enter False)
            , onBlur (Exit False)
            ]
            []
        ]
