module Screens.Game.Updates where

import List exposing (take, (::))
import Task exposing (Task, succeed, map, andThen)
import Task.Extra exposing (delay)
import Time exposing (millisecond, second)
import String
import Time exposing (Time)
import Signal
import Result exposing (Result(Ok, Err))
import Effects exposing (Effects, Never, none, tick)

import AppTypes exposing (..)
import Models exposing (..)
import Screens.Game.Types exposing (..)
import ServerApi
import Game.Models exposing (defaultGame, GameState)
import Game.Steps exposing (gameStep)
import Game.Inputs exposing (..)
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr GameAction


chat : Signal.Mailbox String
chat =
  Signal.mailbox ""


mount : String -> (Screen, Effects Action)
mount id =
  taskRes initial (loadLiveTrack id)


update : Player -> Action -> Screen -> (Screen, Effects Action)
update player action screen =
  case action of

    LoadLiveTrack result ->
      case result of
        Ok liveTrack ->
          res screen (tick <| InitGameState liveTrack)
        Err _ ->
          res { screen | notFound = True } none

    InitGameState liveTrack time ->
      let
        gameState = defaultGame time liveTrack.track.course player
        newScreen = { screen | gameState = Just gameState }
          |> applyLiveTrack liveTrack
      in
        res newScreen pingServer

    PingServer time ->
      if screen.live then
        res screen none
      else
        res { screen | gameState = updateTime time screen.gameState } pingServer

    GameUpdate gameInput ->
      let
        newGameState = Maybe.map (gameStep gameInput) screen.gameState
      in
        res { screen | gameState = newGameState, live = True } none

    EnterChat ->
      let
        newGameState = Maybe.map (\gs -> { gs | chatting = True }) screen.gameState
      in
        res { screen | gameState = newGameState } none

    LeaveChat ->
      let
        newGameState = Maybe.map (\gs -> { gs | chatting = False }) screen.gameState
      in
        res { screen | gameState = newGameState } none

    UpdateMessageField s ->
      res { screen | messageField = s } none

    SubmitMessage ->
      if screen.live then
        taskRes { screen | messageField = "" } (sendMessage screen.messageField)
      else
        res screen none

    NewMessage msg ->
      res { screen | messages = take 30 (msg :: screen.messages) } none

    UpdateLiveTrack liveTrack ->
      res (applyLiveTrack liveTrack screen) none

    NoOp ->
      res screen none


applyLiveTrack : LiveTrack -> Screen -> Screen
applyLiveTrack ({track, players, races} as liveTrack) screen =
  let
    racePlayers = List.concatMap .players races
    inRace p = List.member p racePlayers
    freePlayers = List.filter (not << inRace) players
  in
    { screen | liveTrack = Just liveTrack, races = races, freePlayers = freePlayers }

loadLiveTrack : String -> Task Never Action
loadLiveTrack id =
  ServerApi.getLiveTrack id
    |> Task.map LoadLiveTrack


pingServer : Effects Action
pingServer =
  tick PingServer


sendMessage : String -> Task error Action
sendMessage content =
  if String.isEmpty content then
    Task.succeed NoOp
  else
    Signal.send chat.address content
      |> Task.map (\_ -> NoOp)


updateTime : Time -> Maybe GameState -> Maybe GameState
updateTime time =
  let
    updateTime timers t = { timers | localTime = time }
  in
    Maybe.map (\gs -> { gs | timers = updateTime gs.timers time })


