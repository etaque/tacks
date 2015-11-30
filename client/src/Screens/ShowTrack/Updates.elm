module Screens.ShowTrack.Updates where

import Task exposing (Task, succeed, map, andThen)

import AppTypes exposing (..)
import Screens.ShowTrack.Types exposing (..)
import ServerApi


addr : Signal.Address Action
addr =
  Signal.forwardTo appActionsMailbox.address (ShowTrackAction >> ScreenAction)


type alias Update = AppTypes.ScreenUpdate Screen


mount : String -> Update
mount slug =
  let
    initial =
      { track = Nothing
      , notFound = False
      }
  in
    react initial (loadTrack slug)


update : Action -> Screen -> Update
update action screen =
  case action of

    SetTrack track ->
      local { screen | track = Just track }

    TrackNotFound ->
      local { screen | notFound = True }


loadTrack : String -> Task Never ()
loadTrack slug =
  ServerApi.getTrack slug `andThen`
    \result ->
      case result of
        Ok track ->
          Signal.send addr (SetTrack track)
        Err _ ->
          Task.succeed ()
