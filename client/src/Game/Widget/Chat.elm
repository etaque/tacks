module Game.Widget.Chat exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import View.Utils exposing (..)
import Game.Shared exposing (..)
import Game.Msg exposing (..)


messages : Chat -> Html ChatMsg
messages model =
    div
        [ class "chat-messages"
        , id chatMessagesId
        ]
        [ ul
            [ class "list-unstyled" ]
            (List.map messageItem (List.reverse model.messages))
        ]


messageItem : Message -> Html ChatMsg
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


inputField : Chat -> Html ChatMsg
inputField { field } =
    div
        [ class "chat-input" ]
        [ input
            [ type_ "text"
            , id chatFieldId
            , value field
            , placeholder "press Enter to chat"
            , onInput UpdateField
            , onFocus (EnterChat False)
            , onBlur (ExitChat False)
            ]
            []
        ]
