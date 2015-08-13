module Screens.Game.Updates where

import List exposing (take, (::))
import Task exposing (Task, succeed, map, andThen)
import Task.Extra exposing (delay)
import Time exposing (millisecond)
import Http
import String

import AppTypes exposing (local, react, request, Clock)
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
      { track = Nothing
      , gameState = Nothing
      , live = False
      , messages = []
      , messageField = ""
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

    _ ->
      local screen

loadTrack : String -> Task Http.Error ()
loadTrack slug =
  ServerApi.getTrack slug `andThen`
    \track -> Signal.send actions.address (SetTrack track)


pingServer : Task Http.Error ()
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
