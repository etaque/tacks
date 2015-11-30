module Screens.Register.Updates where

import Task exposing (Task, succeed, map, andThen)
import Dict exposing (Dict)

import AppTypes exposing (..)
import Screens.Register.Types exposing (..)
import ServerApi


addr : Signal.Address Action
addr =
  Signal.forwardTo appActionsMailbox.address (RegisterAction >> ScreenAction)

type alias Update = AppTypes.ScreenUpdate Screen


mount : Update
mount =
  let
    initial =
      { handle = ""
      , email = ""
      , password = ""
      , loading = False
      , errors = Dict.empty
      }
  in
    local initial


update : Action -> Screen -> Update
update action screen =
  case action of

    SetHandle h ->
      local { screen | handle = h }

    SetEmail e ->
      local { screen | email = e }

    SetPassword p ->
      local { screen | password = p }

    Submit ->
      react { screen | loading = True, errors = Dict.empty }
        (submitTask screen)

    FormSuccess player ->
      react { screen | loading = False, errors = Dict.empty }
        (Signal.send appActionsMailbox.address (AppTypes.SetPlayer player))

    FormFailure errors ->
      local { screen | loading = False, errors = errors }


submitTask : Screen -> Task Never ()
submitTask screen =
  ServerApi.postRegister screen.email screen.handle screen.password
    `andThen` \result ->
      case result of
        Ok player ->
          Signal.send addr (FormSuccess player)
        Err errors ->
          Signal.send addr (FormFailure errors)

