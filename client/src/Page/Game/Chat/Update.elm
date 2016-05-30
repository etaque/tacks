module Page.Game.Chat.Update exposing (..)

import String
import Response exposing (..)
import Update.Utils exposing (..)
import Page.Game.Chat.Model exposing (..)
import Game.Outputs as Output
import Ports
import Keyboard


subscriptions : String -> Model -> Sub Msg
subscriptions host model =
  Keyboard.downs (keyCodeToMsg model)


update : (Output.ServerMsg -> Cmd Msg) -> Msg -> Model -> Response Model Msg
update serverSocket msg model =
  case msg of
    Enter withFocus ->
      res { model | focus = True } (Ports.setFocus fieldId)

    Exit withBlur ->
      let
        cmd =
          if withBlur then
            Ports.setBlur fieldId
          else
            Cmd.none
      in
        res { model | focus = False } cmd

    UpdateField s ->
      res { model | field = s } Cmd.none

    Submit ->
      if not (String.isEmpty model.field) then
        res
          { model | field = "" }
          (Cmd.batch [ serverSocket (Output.SendMessage model.field), Ports.setBlur fieldId ])
      else
        res model (Ports.setBlur fieldId)

    AddMessage msg ->
      res
        { model | messages = List.take 30 (msg :: model.messages) }
        (Ports.scrollToBottom messagesId)

    NoOp ->
      res model Cmd.none


keyCodeToMsg : Model -> Int -> Msg
keyCodeToMsg model code =
  if model.focus then
    if code == enter then
        Submit
    else if code == esc then
      Exit True
    else
      NoOp
  else
    if code == enter then
      Enter True
    else
      NoOp


esc : Int
esc =
  27


enter : Int
enter =
  13

