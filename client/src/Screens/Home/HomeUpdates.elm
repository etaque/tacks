module Screens.Home.HomeUpdates where

import Task exposing (Task, succeed, map, andThen)
import Time exposing (second)
import Http

import AppTypes exposing (local, react, request)
import Models exposing (..)
import Screens.Home.HomeTypes exposing (..)
import ServerApi


actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp


type alias Update = AppTypes.ScreenUpdate Screen Action


mount : Player -> Update
mount player =
  let
    initial =
      { handle = Maybe.withDefault "" player.handle
      , liveStatus = { liveTracks = [], onlinePlayers = [] }
      }
  in
    react initial refreshLiveStatus


update : Action -> Screen -> Update
update action screen =
  case action of

    SetLiveStatus liveStatus ->
      react { screen | liveStatus <- liveStatus }
        (Task.sleep (5 * second) `andThen` \_ -> refreshLiveStatus)

    SetHandle handle ->
      local { screen | handle <- handle }

    SubmitHandle ->
      react screen (map SubmitHandleSuccess (ServerApi.postHandle screen.handle))

    SubmitHandleSuccess player ->
      request screen (AppTypes.SetPlayer player)


refreshLiveStatus : Task Http.Error Action
refreshLiveStatus =
  map SetLiveStatus ServerApi.getLiveStatus

