module Screens.Home.Updates where

import Task exposing (Task, succeed, map, andThen)
import Task.Extra exposing (delay)
import Time exposing (second)
import Http

import AppTypes exposing (local, react, request, Never)
import Models exposing (..)
import Screens.Home.Types exposing (..)
import ServerApi


actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp


type alias Update = AppTypes.ScreenUpdate Screen


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
        (delay (5 * second) refreshLiveStatus)

    SetHandle handle ->
      local { screen | handle <- handle }

    SubmitHandle ->
      react screen <| (ServerApi.postHandle screen.handle) `andThen`
        \result ->
          case result of
            Ok player ->
              Signal.send actions.address (SubmitHandleSuccess player)
            Err errors ->
              -- TODO
              Task.succeed ()

    SubmitHandleSuccess player ->
      request screen (AppTypes.SetPlayer player)

    CreateTrack ->
      react screen <| (ServerApi.createTrack) `andThen`
        \result ->
          case result of
            Ok track ->
              Signal.send actions.address (TrackCreated track.id)
            Err _ ->
              -- TODO
              Task.succeed ()

    TrackCreated id ->
      request screen (AppTypes.SetPath ("/edit/" ++ id))

    _ ->
      local screen

refreshLiveStatus : Task Never ()
refreshLiveStatus =
  ServerApi.getLiveStatus `andThen`
    \result ->
      case result of
        Ok liveStatus ->
          Signal.send actions.address (SetLiveStatus liveStatus)
        Err _ ->
          Task.succeed ()


