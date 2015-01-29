module Chat.Views where

import Signal
import List (..)
import Maybe as M
import String as S
import Json.Decode as Json

import Html (..)
import Html.Attributes (..)
import Html.Events (..)

import Game (Player)
import Chat.Model (..)
import Messages (Translator)


localUpdates : Signal.Channel Action
localUpdates = Signal.channel NoOp


view : Translator -> Model -> Html
view t model =
  let
    leftElements =
      [ messagesList model.messages
      , messageForm t model.messageField
      ]
    rightElements = if model.currentPlayer.user
      then
        [ statusForm t model.statusField
        , playersList model.players
        ]
      else
        [ playersList model.players ]
  in
    div [ class "chat-wrapper" ]
      [ div [ class "chat-top" ] [ text (t "chat.title") ]
      , div [ class "chat-left" ] leftElements
      , div [ class "chat-right" ] rightElements
      ]

messagesList : List Message -> Html
messagesList messages =
  div [ class "chat-box" ]
    [ ul [ class "list-unstyled chat-messages" ] (map messageItem messages) ]

messageItem : Message -> Html
messageItem message =
  li []
    [ span [ class "player-avatar" ] [ text (M.withDefault "Anonymous" message.player.handle) ]
    , span [ class "content" ] [ text message.content ]
    ]

statusForm : Translator -> String -> Html
statusForm t field =
  div [ class "chat-status-form" ]
    [ input
      [ type' "text"
      , class "form-control"
      , value field
      , placeholder (t "chat.statusPlaceholder")
      , on "input" targetValue (Signal.send localUpdates << UpdateStatusField)
      , onEnter (Signal.send localUpdates (SubmitStatus field))
      ]
      []
    ]

playersList : List Player -> Html
playersList players =
  ul [ class "list-unstyled chat-players" ] (map playerItem players)

playerItem : Player -> Html
playerItem player =
  let
    status = case player.status of
      Just s -> span [ class "status" ] [ text s ]
      Nothing -> text ""
  in
    li [] [ playerWithAvatar player, status ]


playerWithAvatar : Player -> Html
playerWithAvatar player =
  let
    avatarUrl = case player.avatarId of
      Just id -> "/avatars/" ++ id
      Nothing -> if player.user then "/assets/images/avatar-user.png" else "/assets/images/avatar-guest.png"
    avatarImg = img [ src avatarUrl, class "avatar", width 19, height 19 ] []
    handleSpan = span [ class "handle" ] [ text (M.withDefault "Anonymous" player.handle) ]
    handle = M.withDefault "" player.handle
  in
    if player.guest
      then
        span [ class "player-avatar" ] [avatarImg, text " ", handleSpan]
      else
        a [ href ("/players/" ++ handle), target "_blank", class "player-avatar" ] [avatarImg, text " ", handleSpan]

onEnter : Signal.Message -> Attribute
onEnter message =
    on "keydown"
      (Json.customDecoder keyCode is13)
      (always message)

is13 : Int -> Result String ()
is13 code =
  if code == 13 then Ok () else Err "not the right key code"

messageForm : Translator -> String -> Html
messageForm t field =
  div [ class "chat-message-form" ]
    [ input
      [ type' "text"
      , class "form-control"
      , value field
      , placeholder (t "chat.messagePlaceholder")
      , on "input" targetValue (Signal.send localUpdates << UpdateMessageField)
      , onEnter (Signal.send localUpdates (SubmitMessage field))
      ]
      []
    ]
