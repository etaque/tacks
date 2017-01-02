module Game.Widget.Chat exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import View.Utils as Utils
import Game.Shared exposing (..)
import Game.Msg exposing (..)


view : Chat -> Html ChatMsg
view model =
    aside
        [ classList
            [ ( "chat-layer", True )
            , ( "focus", model.focus )
            ]
        ]
        [ div
            [ classList
                [ ( "chat-messages", True )
                , ( "empty", List.isEmpty model.messages )
                , ( "visible", model.showMessages )
                ]
            , id chatMessagesId
            ]
            [ div
                [ class "chat-messages-toggle"
                , onClick (ShowMessages (not model.showMessages))
                ]
                [ Utils.mIcon "close" [] ]
            , ul
                [ class "list-unstyled" ]
                (List.map messageItem (List.reverse model.messages))
            ]
        , inputField model
        ]


messageItem : Message -> Html msg
messageItem { player, content, time } =
    li
        []
        [ span
            [ class "handle" ]
            [ text (Utils.playerHandle player) ]
        , span
            [ class "content" ]
            [ text content ]
        ]


inputField : Chat -> Html ChatMsg
inputField model =
    let
        buttonMsg =
            if model.focus then
                ExitChat
            else
                EnterChat
    in
        div
            [ class "chat-input" ]
            [ div
                [ class "chat-btn"
                , onClick buttonMsg
                ]
                [ Utils.mIcon "chat" []
                , div
                    [ classList
                        [ ( "unread-count", True )
                        , ( "no-unread", model.unreadCount == 0 )
                        ]
                    ]
                    [ text (toString model.unreadCount) ]
                ]
            , input
                [ type_ "text"
                , id chatFieldId
                , value model.field
                , placeholder "press Enter to chat"
                , onInput UpdateField
                ]
                []
            ]
