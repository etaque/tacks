module Page.Game.Update exposing (..)

import Time exposing (millisecond, second)
import String
import Time exposing (Time)
import Dict exposing (Dict)
import Result exposing (Result(Ok, Err))
import Response exposing (..)
import Model
import Model.Shared exposing (..)
import Page.Game.Model exposing (..)
import ServerApi
import Game.Models exposing (defaultGame, GameState)
import Game.Steps exposing (gameStep)
import Game.Outputs as Output
import Update.Utils as Utils
import Task


mount : String -> Response Model Msg
mount id =
  res initial (load id)


update : Player -> Msg -> Model -> Response Model Msg
update player msg model =
  case msg of
    Load liveTrackResult courseResult ->
      case ( liveTrackResult, courseResult ) of
        ( Ok liveTrack, Ok course ) ->
          res model (tick <| InitGameState liveTrack course)

        _ ->
          res { model | notFound = True } Cmd.none

    InitGameState liveTrack course time ->
      let
        gameState =
          defaultGame time course player

        newModel =
          { model | gameState = Just gameState }
            |> applyLiveTrack liveTrack
      in
        res newModel pingServer

    PingServer time ->
      if model.live then
        res model Cmd.none
      else
        res { model | gameState = updateTime time model.gameState } pingServer

    SetTab tab ->
      res { model | tab = tab } Cmd.none

    StartRace ->
      let
        startTask =
          Signal.send Output.serverAddress Output.StartRace
            |> Task.map (\_ -> NoOp)
      in
        taskRes model startTask

    ExitRace ->
      let
        newModel =
          { model | gameState = Maybe.map clearCrossedGates model.gameState }

        exitTask =
          Signal.send Output.serverAddress Output.EscapeRace
            |> Task.map (\_ -> NoOp)
      in
        taskRes newModel exitTask

    GameUpdate gameInput ->
      let
        newGameState =
          Maybe.map (gameStep gameInput) model.gameState
      in
        res { model | gameState = newGameState, live = True } Cmd.none

    EnterChat ->
      let
        newGameState =
          Maybe.map (\gs -> { gs | chatting = True }) model.gameState
      in
        res { model | gameState = newGameState } Cmd.none

    LeaveChat ->
      let
        newGameState =
          Maybe.map (\gs -> { gs | chatting = False }) model.gameState
      in
        res { model | gameState = newGameState } Cmd.none

    UpdateMessageField s ->
      res { model | messageField = s } Cmd.none

    SubmitMessage ->
      if model.live then
        taskRes { model | messageField = "" } (sendMessage model.messageField)
      else
        res model Cmd.none

    NewMessage msg ->
      res { model | messages = take 30 (msg :: model.messages) } Cmd.none

    AddGhost runId player ->
      let
        newGhostRuns =
          Dict.insert runId player model.ghostRuns
      in
        taskRes { model | ghostRuns = newGhostRuns } (addGhost runId player)

    RemoveGhost runId ->
      let
        newGhostRuns =
          Dict.remove runId model.ghostRuns
      in
        taskRes { model | ghostRuns = newGhostRuns } (removeGhost runId)

    UpdateLiveTrack liveTrack ->
      res (applyLiveTrack liveTrack model) Cmd.none

    NoOp ->
      res model Cmd.none


applyLiveTrack : LiveTrack -> Model -> Model
applyLiveTrack ({ track, players, races } as liveTrack) model =
  let
    racePlayers =
      List.concatMap .players races

    inRace p =
      List.member p racePlayers

    freePlayers =
      List.filter (not << inRace) players
  in
    { model | liveTrack = Just liveTrack, races = races, freePlayers = freePlayers }


load : String -> Cmd Msg
load id =
  Task.map2
    Load
    (ServerApi.getLiveTrack id)
    (ServerApi.getCourse id)
    |> Task.performSucceed


pingServer : Cmd Msg
pingServer =
  tick PingServer


sendMessage : String -> Task error Msg
sendMessage content =
  if String.isEmpty content then
    Task.succeed NoOp
  else
    Signal.send Output.serverAddress (Output.SendMessage content)
      |> Task.map (\_ -> NoOp)


addGhost : String -> Player -> Task error Msg
addGhost runId player =
  Signal.send Output.serverAddress (Output.AddGhost runId player)
    |> Task.map (\_ -> NoOp)


removeGhost : String -> Task error Msg
removeGhost runId =
  Signal.send Output.serverAddress (Output.RemoveGhost runId)
    |> Task.map (\_ -> NoOp)


clearCrossedGates : GameState -> GameState
clearCrossedGates ({ playerState } as gameState) =
  { gameState | playerState = { playerState | crossedGates = [] } }


updateTime : Time -> Maybe GameState -> Maybe GameState
updateTime time =
  let
    updateTime timers t =
      { timers | localTime = time }
  in
    Maybe.map (\gs -> { gs | timers = updateTime gs.timers time })
