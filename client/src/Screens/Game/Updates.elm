module Screens.Game.Updates where

import Task exposing (Task, succeed, map, andThen)
import Task.Extra exposing (delay)
import Time exposing (millisecond)
import Http

import AppTypes exposing (local, react, request, Clock)
import Models exposing (..)
import Screens.Game.Types exposing (..)
import ServerApi
import Game.Models exposing (defaultGame, GameState)
import Game.Steps exposing (gameStep)
import Game.Inputs exposing (..)


actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp


type alias Update = AppTypes.ScreenUpdate Screen


mount : String -> Update
mount slug =
  let
    initial =
      { track = Nothing
      , gameState = Nothing
      , live = False
      , notFound = False
      }
  in
    react initial (loadTrack slug)


update : Player -> Clock -> Action -> Screen -> Update
update player clock action screen =
  case action of

    SetTrack track ->
      let
        gameState = defaultGame clock.time track.course player
        newScreen = { screen | track <- Just track, gameState <- Just gameState }
      in
        react newScreen pingServer

    PingServer ->
      if screen.live then
        local screen
      else
        react { screen | gameState <- updateTime clock screen.gameState} pingServer

    TrackNotFound ->
      local { screen | notFound <- True }

    GameUpdate gameInput ->
      let
        newGameState = Maybe.map (gameStep clock gameInput) screen.gameState
      in
        local { screen | gameState <- newGameState, live <- True }

    _ ->
      local screen

loadTrack : String -> Task Http.Error ()
loadTrack slug =
  ServerApi.getTrack slug `andThen`
    \track -> Signal.send actions.address (SetTrack track)


pingServer : Task Http.Error ()
pingServer =
  delay (30 * millisecond) (Signal.send actions.address PingServer)

updateTime : Clock -> Maybe GameState -> Maybe GameState
updateTime clock = Maybe.map (\gs -> { gs | localTime <- clock.time })

mapGameUpdate : KeyboardInput -> (Int,Int) -> Maybe RaceInput -> Maybe Action
mapGameUpdate keyboardInput dims maybeRaceInput =
  Maybe.map (GameInput keyboardInput dims) maybeRaceInput
    |> Maybe.map GameUpdate
