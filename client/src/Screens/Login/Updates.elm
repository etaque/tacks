module Screens.Login.Updates where

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))

import AppTypes exposing (..)
import Screens.Login.Types exposing (..)
import ServerApi


addr : Signal.Address Action
addr =
  Signal.forwardTo appActionsMailbox.address (LoginAction >> ScreenAction)

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

    NoOp ->
      local screen

    SetEmail e ->
      local { screen | email = e }

    SetPassword p ->
      local { screen | password = p }

    Submit ->
      react { screen | loading = True } (submitTask screen)

    Success player ->
      react { screen | loading = False, error = False }
        (Signal.send appActionsMailbox.address (AppTypes.SetPlayer player))

    Error ->
      local { screen | loading = False, error = True }


submitTask : Screen -> Task Never ()
submitTask screen =
  ServerApi.postLogin screen.email screen.password
    `andThen` \result ->
      case result of
        Ok player ->
          Signal.send addr (Success player)
        Err _ ->
          Signal.send addr Error


