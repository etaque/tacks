module Screens.Game.Updates where

import List exposing (take, (::))
import Task exposing (Task, succeed, map, andThen)
import Task.Extra exposing (delay)
import Time exposing (millisecond, second)
import Http
import String

import AppTypes exposing (local, react, request, Clock, Never)
import Models exposing (..)
import Screens.Game.Types exposing (..)
import ServerApi
import Game.Models exposing (defaultGame, GameState)
import Game.Steps exposing (gameStep)
import Game.Inputs exposing (..)


actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp


chat : Signal.Mailbox String
chat = Signal.mailbox ""


type alias Update = AppTypes.ScreenUpdate Screen


mount : String -> Update
mount slug =
  let
    initial =
      { liveTrack = Nothing
      , gameState = Nothing
      , races = []
      , freePlayers = []
      , live = False
      , messages = []
      , messageField = ""
      , notFound = False
      }
  in
    react initial (loadLiveTrack slug)


update : Player -> Clock -> Action -> Screen -> Update
update player clock action screen =
  case action of

    SetLiveTrack liveTrack ->
      let
        gameState = defaultGame clock.time liveTrack.track.course player
        newScreen = { screen | gameState <- Just gameState }
          |> applyLiveTrack liveTrack
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

    EnterChat ->
      let
        newGameState = Maybe.map (\gs -> { gs | chatting <- True }) screen.gameState
      in
        local { screen | gameState <- newGameState }

    LeaveChat ->
      let
        newGameState = Maybe.map (\gs -> { gs | chatting <- False }) screen.gameState
      in
        local { screen | gameState <- newGameState }

    UpdateMessageField s ->
      local { screen | messageField <- s }

    SubmitMessage ->
      if screen.live then
        let
          msgTask = sendMessage screen.messageField
        in
          react { screen | messageField <- "" } msgTask
      else
        local screen

    NewMessage msg ->
      local { screen | messages <- take 30 (msg :: screen.messages) }

    UpdateLiveTrack liveTrack ->
      local (applyLiveTrack liveTrack screen)

    _ ->
      local screen


applyLiveTrack : LiveTrack -> Screen -> Screen
applyLiveTrack ({track, players, races} as liveTrack) screen =
  let
    racePlayers = List.concatMap .players races
    inRace p = List.member p racePlayers
    freePlayers = List.filter (not << inRace) players
  in
    { screen | liveTrack <- Just liveTrack, races <- races, freePlayers <- freePlayers }

loadLiveTrack : String -> Task Never ()
loadLiveTrack slug =
  ServerApi.getLiveTrack slug `andThen`
    \result ->
      case result of
        Ok liveTrack ->
          Signal.send actions.address (SetLiveTrack liveTrack)
        Err _ ->
          -- TODO handle failure
          Task.succeed ()


-- updateLiveTrack : String -> Task Http.Error ()
-- updateLiveTrack slug =
--   delay (2 * second) (ServerApi.getLiveTrack slug) `andThen`
--     \liveTrack -> Signal.send actions.address (UpdateLiveTrack liveTrack)


pingServer : Task Never ()
pingServer =
  delay (30 * millisecond) (Signal.send actions.address PingServer)


sendMessage : String -> Task error ()
sendMessage content =
  if String.isEmpty content then
    Task.succeed ()
  else
    Signal.send chat.address content


updateTime : Clock -> Maybe GameState -> Maybe GameState
updateTime clock = Maybe.map (\gs -> { gs | localTime <- clock.time })


mapGameUpdate : KeyboardInput -> (Int,Int) -> Maybe RaceInput -> Maybe Action
mapGameUpdate keyboardInput dims maybeRaceInput =
  Maybe.map (GameInput keyboardInput dims) maybeRaceInput
    |> Maybe.map GameUpdate
