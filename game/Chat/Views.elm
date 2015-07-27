module Chat.Views where

import Signal
import List exposing (..)
import Maybe as M
import String as S
import Json.Decode as Json

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Game exposing (Player)
import Chat.Model exposing (..)
import Messages exposing (Translator)


localUpdates : Signal.Mailbox Action
localUpdates = Signal.mailbox NoOp


view : Translator -> Model -> Html
view t model =
  let
    leftElements =
      [ div [ class "chat-top" ] [ text (t "chat.title") ]
      , messagesList model.messages
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
      [ div [ class "chat-left" ] leftElements
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
      , on "input" targetValue (\s -> Signal.message localUpdates.address (UpdateStatusField s))
      , onEnter localUpdates.address (SubmitStatus field)
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


onEnter : Signal.Address a -> a -> Attribute
onEnter address value =
    on "keydown"
      (Json.customDecoder keyCode is13)
      (\_ -> Signal.message address value)

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
      , on "input" targetValue (\msg -> Signal.message localUpdates.address (UpdateMessageField msg))
      , onEnter localUpdates.address (SubmitMessage field)
      ]
      []
    ]
