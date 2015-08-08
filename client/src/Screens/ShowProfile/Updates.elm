module Screens.ShowProfile.Updates where

import Task exposing (Task, succeed, map, andThen)
import Time exposing (second)
import Http

import AppTypes exposing (local, react, request)
import Models exposing (..)
import Screens.ShowProfile.Types exposing (..)
import ServerApi


actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp


type alias Update = AppTypes.ScreenUpdate Screen


mount : Player -> Update
mount player =
  let
    initial = { player = player }
  in
    local initial


update : Action -> Screen -> Update
update action screen =
  case action of

    _ ->
      local screen
