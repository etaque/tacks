module Chat.Main where

import Maybe as M
import String as S
import Json.Decode as Json
import Result
import Time exposing (..)

import Html exposing (..)

import Messages
import Chat.Model exposing (..)
import Chat.Views as V exposing (localUpdates)


update : Action -> Model -> Model
update action model =
  case action of

    SetPlayer p ->
      { model |
        currentPlayer <- p,
        statusField <- M.withDefault "" p.status
      }

    UpdateMessageField s ->
      { model |
        messageField <- s
      }

    UpdateStatusField s ->
      { model |
        statusField <- s
      }

    UpdatePlayers players ->
      { model |
        players <- players
      }

    NewMessage player content ->
      { model |
        messages <- model.messages ++ [{ player = player, content = content }]
      }

    SubmitMessage content ->
      { model |
        messageField <- ""
      }

    _ -> model

port serverInput : Signal Json.Value

port messagesStore: Json.Value

translator : Messages.Translator
translator = Messages.translator (Messages.fromJson messagesStore)

main : Signal Html
main = Signal.map (V.view translator) model

model : Signal Model
model = Signal.foldp update emptyModel updates

handleServerInput : Json.Value -> Action
handleServerInput value =
  case Json.decodeValue actionDecoder value of
    Err e -> NoOp
    Ok action -> action

updates : Signal Action
updates = Signal.mergeMany
  [ localUpdates.signal
  , Signal.map handleServerInput serverInput
  ]

isOutputAction : Action -> Bool
isOutputAction action =
  case action of
    SubmitMessage content -> not (S.isEmpty content)
    SubmitStatus _ -> True
    _ -> False

port localOutput : Signal Json.Value
port localOutput =
  let
    output = Signal.mergeMany
      [ Signal.filter isOutputAction NoOp updates
      , Signal.map (\_ -> Ping) (every (10 * second))
      ]
  in
    Signal.map actionEncoder output

port scrollDown : Signal ()
port scrollDown =
  let
    isNewMessage action = case action of
      NewMessage _ _ -> True
      _ -> False
  in
    Signal.filter isNewMessage NoOp updates
      |> Signal.map (\_ -> ())
