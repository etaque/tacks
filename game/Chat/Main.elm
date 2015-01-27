module Chat.Main where

import Signal
import List (..)
import Maybe as M
import String as S
import Json.Decode as Json

import Html (..)
import Html.Attributes (..)
import Html.Events (..)

import Game (Player, defaultPlayer)
import Chat.Model (..)

import Debug

update : Action -> Model -> Model
update action model =
  case action of

    NoOp -> model

    SetPlayer p ->
      { model |
        currentPlayer <- p
      }

    UpdateField s ->
      { model |
        field <- s
      }

    UpdatePlayers players ->
      { model |
        players <- players
      }

    NewMessage player content ->
      { model |
        messages <- model.messages ++ [{ player = player, content = content }]
      }


view : Model -> Html
view model =
  div [ class "chat-wrapper" ]
    [ div [ class "chat-messages" ] [ messagesList model.messages ]
    , div [ class "chat-players" ] [ playersList model.players ]
    , messageForm model.field
    ]

messagesList : List Message -> Html
messagesList messages =
  let
    messageItems = map (\m -> li [] [ text m.content ]) messages
  in
    ul [] messageItems

playersList : List Player -> Html
playersList players =
  let
    playersItems = map (\p -> li [] [ text (M.withDefault "Anonymous" p.handle) ]) players
  in
    ul [] playersItems

onEnter : Signal.Message -> Attribute
onEnter message =
    on "keydown"
      (Json.customDecoder keyCode is13)
      (always message)

is13 : Int -> Result String ()
is13 code =
  if code == 13 then Ok () else Err "not the right key code"

messageForm : String -> Html
messageForm field =
  div [ class "form-chat" ]
    [ input
      [ type' "text"
      , value field
      , on "input" targetValue (Signal.send localUpdates << UpdateField)
      , onEnter (Signal.send submitMessages { content = field })
      ]
      []
    , input
      [ type' "submit"
      , value "Submit"
      , onClick (Signal.send submitMessages { content = field })
      ]
      []
    ]


main : Signal Html
main = Signal.map view model

model : Signal Model
model = Signal.foldp update emptyModel updates

port serverInput : Signal Json.Value

handleServerInput : Json.Value -> Action
handleServerInput value =
  case Json.decodeValue actionDecoder value of
    Err e -> NoOp
    Ok action -> action

localUpdates : Signal.Channel Action
localUpdates = Signal.channel NoOp

updates : Signal Action
updates = Signal.mergeMany
  [ Signal.subscribe localUpdates
  , Signal.map handleServerInput serverInput
  , Signal.map (\_ -> UpdateField "") (Signal.subscribe submitMessages)
  ]

submitMessages : Signal.Channel SubmitMessage
submitMessages = Signal.channel { content = "" }

port localOutput : Signal SubmitMessage
port localOutput = Signal.subscribe submitMessages

