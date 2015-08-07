module Screens.Login.Updates where

import Task exposing (Task, succeed, map, andThen)
import Http

import AppTypes exposing (local, react, request)
import Screens.Login.Types exposing (..)
import ServerApi


actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp


type alias Update = AppTypes.ScreenUpdate Screen


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
      react screen <| (ServerApi.postLogin screen.email screen.password)
        `andThen` (\player -> Signal.send actions.address (Success player))


    Success player ->
      request { screen | error <- False }
        (AppTypes.SetPlayer player)

    Error ->
      local { screen | error <- True }



