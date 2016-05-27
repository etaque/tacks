module Page.Game.Update exposing (..)

import Time exposing (millisecond, second)
import String
import Time exposing (Time)
import Dict exposing (Dict)
import Result exposing (Result(Ok, Err))
import Response exposing (..)
import Model.Shared exposing (..)
import Page.Game.Model exposing (..)
import Page.Game.Decoders as Decoders
import Update.Utils exposing (..)
import ServerApi
import Game.Models exposing (defaultGame, GameState)
import Game.Steps exposing (gameStep)
import Game.Outputs as Output
import Game.Inputs as Input
import Task
import CoreExtra
import WebSocket
import AnimationFrame
import Keyboard.Extra as Keyboard
import Window


subscriptions : String -> Model -> Sub Msg
subscriptions host model =
  case model.liveTrack of
    Just liveTrack ->
      Sub.batch
        [ WebSocket.listen
            (ServerApi.gameSocket host liveTrack.track.id)
            Decoders.decodeStringMsg
        , AnimationFrame.times Frame
        , Sub.map KeyboardMsg Keyboard.subscriptions
        , Window.resizes WindowSize
        ]

    _ ->
      Sub.none


mount : String -> Response Model Msg
mount id =
  let
    cmd =
      Cmd.batch
        [ load id
        , performSucceed WindowSize Window.size
        ]
  in
    res initial cmd


update : Player -> String -> Msg -> Model -> Response Model Msg
update player host msg model =
  case msg of
    Load liveTrackResult courseResult ->
      case ( liveTrackResult, courseResult ) of
        ( Ok liveTrack, Ok course ) ->
          performSucceed (InitGameState liveTrack course) Time.now
            |> res model

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
        res newModel Cmd.none

    KeyboardMsg keyboardMsg ->
      let
        ( keyboard, keyboardCmd ) =
          Keyboard.update keyboardMsg model.keyboard
      in
        res { model | keyboard = keyboard } (Cmd.map KeyboardMsg keyboardCmd)

    WindowSize size ->
      res { model | dims = ( size.width, size.height) } Cmd.none

    RaceUpdate raceInput ->
      res { model | raceInput = raceInput } Cmd.none

    Frame time ->
      case model.gameState of
        Just gameState ->
          let
            gameInput =
              Input.GameInput
                model.raceInput
                (Input.keyboardInput model.keyboard)
                model.dims
                time

            newGameState =
              gameStep gameInput gameState

            serverCmd =
              Output.sendToServer
                host
                model.liveTrack
                (Output.UpdatePlayer (Output.playerOutput gameState))
          in
            res { model | gameState = Just newGameState } serverCmd

        Nothing ->
          res model Cmd.none

    SetTab tab ->
      res { model | tab = tab } Cmd.none

    StartRace ->
      let
        start =
          Output.sendToServer host model.liveTrack Output.StartRace
      in
        res model start

    ExitRace ->
      let
        newModel =
          { model | gameState = Maybe.map clearCrossedGates model.gameState }

        escape =
          Output.sendToServer host model.liveTrack Output.EscapeRace
      in
        res newModel escape

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
      if not (String.isEmpty model.messageField) then
        res
          { model | messageField = "" }
          (Output.sendToServer host model.liveTrack (Output.SendMessage model.messageField))
      else
        res model Cmd.none

    NewMessage msg ->
      res { model | messages = List.take 30 (msg :: model.messages) } Cmd.none

    AddGhost runId player ->
      let
        newGhostRuns =
          Dict.insert runId player model.ghostRuns

        cmd =
          Output.sendToServer host model.liveTrack (Output.AddGhost runId player)
      in
        res { model | ghostRuns = newGhostRuns } cmd

    RemoveGhost runId ->
      let
        newGhostRuns =
          Dict.remove runId model.ghostRuns

        cmd =
          Output.sendToServer host model.liveTrack (Output.RemoveGhost runId)
      in
        res { model | ghostRuns = newGhostRuns } cmd

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
  Task.map2 Load (ServerApi.getLiveTrack id) (ServerApi.getCourse id)
    |> performSucceed identity


clearCrossedGates : GameState -> GameState
clearCrossedGates ({ playerState } as gameState) =
  { gameState | playerState = { playerState | crossedGates = [] } }
