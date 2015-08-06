module Screens.Login.LoginUpdates where

import Task exposing (Task, succeed, map)
import Http

import AppTypes exposing (local, react, request)
import Screens.Login.LoginTypes exposing (..)
import ServerApi


actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp


type alias Update = AppTypes.ScreenUpdate Screen Action


mount : Update
mount =
  let
    initial =
      { email = ""
      , password = ""
      , error = False
      }
  in
    local initial


update : Action -> Screen -> Update
update action screen =
  case action of

    SetEmail e ->
      local { screen | email <- e }

    SetPassword p ->
      local { screen | password <- p }

    Submit ->
      react screen
        (map Success (ServerApi.postLogin screen.email screen.password))

    Success player ->
      request { screen | error <- False }
        (AppTypes.SetPlayer player)

    Error ->
      local { screen | error <- True }



