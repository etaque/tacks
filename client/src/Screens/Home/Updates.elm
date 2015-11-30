module Screens.Home.Updates where

import Task exposing (Task, succeed, map, andThen)
import Task.Extra exposing (delay)
import Time exposing (second)
import Signal
import History

import AppTypes exposing (..)
import Models exposing (..)
import Screens.Home.Types exposing (..)
import ServerApi
import Routes


addr : Signal.Address Action
addr =
  Signal.forwardTo appActionsMailbox.address (HomeAction >> ScreenAction)


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
      react { screen | liveStatus = liveStatus }
        (delay (5 * second) refreshLiveStatus)

    SetHandle handle ->
      local { screen | handle = handle }

    SubmitHandle ->
      react screen <| (ServerApi.postHandle screen.handle) `andThen`
        \result ->
          case result of
            Ok player ->
              Signal.send addr (SubmitHandleSuccess player)
            Err errors ->
              -- TODO
              Task.succeed ()

    SubmitHandleSuccess player ->
      react
        screen
        (Signal.send appActionsMailbox.address (AppTypes.SetPlayer player))

    CreateTrack ->
      react screen <| (ServerApi.createTrack) `andThen`
        \result ->
          case result of
            Ok track ->
              Signal.send addr (TrackCreated track.id)
            Err _ ->
              -- TODO
              Task.succeed ()

    TrackCreated id ->
      react screen (History.setPath (Routes.toPath (Routes.EditTrack id)))

    _ ->
      local screen

refreshLiveStatus : Task Never ()
refreshLiveStatus =
  ServerApi.getLiveStatus `andThen`
    \result ->
      case result of
        Ok liveStatus ->
          Signal.send addr (SetLiveStatus liveStatus)
        Err _ ->
          Task.succeed ()


