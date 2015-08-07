module Screens.ShowTrack.Updates where

import Task exposing (Task, succeed, map, andThen)
import Time exposing (second)
import Http

import AppTypes exposing (local, react, request)
import Models exposing (..)
import Screens.ShowTrack.Types exposing (..)
import ServerApi


actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp


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
      local { screen | track <- Just track }

    TrackNotFound ->
      local { screen | notFound <- True }

    _ ->
      local screen

loadTrack : String -> Task Http.Error ()
loadTrack slug =
  ServerApi.getTrack slug `andThen`
    (\track -> Signal.send actions.address (SetTrack track))
