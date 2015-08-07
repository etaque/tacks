module Screens.Register.RegisterUpdates where

import Task exposing (Task, succeed, map, andThen)
import Http

import AppTypes exposing (local, react, request)
import Screens.Register.RegisterTypes exposing (..)
import ServerApi


actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp


type alias Update = AppTypes.ScreenUpdate Screen


mount : Update
mount =
  let
    initial =
      { handle = ""
      , email = ""
      , password = ""
      , error = False
      }
  in
    local initial


update : Action -> Screen -> Update
update action screen =
  case action of

    SetHandle h ->
      local { screen | handle <- h }

    SetEmail e ->
      local { screen | email <- e }

    SetPassword p ->
      local { screen | password <- p }

    Submit ->
      react screen <| (ServerApi.postRegister screen.handle screen.email screen.password)
        `andThen` (\p -> Signal.send actions.address (Success p))

    Success player ->
      request { screen | error <- False }
        (AppTypes.SetPlayer player)

    Error ->
      local { screen | error <- True }




