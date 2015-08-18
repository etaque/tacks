module Screens.Login.Updates where

import Task exposing (Task, succeed, map, andThen)
import Http
import Result exposing (Result(Ok, Err))

import AppTypes exposing (local, react, request, Never)
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
      , loading = False
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
      react { screen | loading <- True } (submitTask screen)

    Success player ->
      request { screen | loading <- False, error <- False }
        (AppTypes.SetPlayer player)

    Error ->
      local { screen | loading <- False, error <- True }


submitTask : Screen -> Task Never ()
submitTask screen =
  ServerApi.postLogin screen.email screen.password
    `andThen` \result ->
      case result of
        Ok player ->
          Signal.send actions.address (Success player)
        Err _ ->
          Signal.send actions.address Error


