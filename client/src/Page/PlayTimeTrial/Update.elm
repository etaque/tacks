module Page.PlayTimeTrial.Update exposing (..)

import Time exposing (millisecond, second)
import Time exposing (Time)
import Dict exposing (Dict)
import Result exposing (Result(Ok, Err))
import Response exposing (..)
import Model.Shared exposing (..)
import Page.PlayTimeTrial.Model exposing (..)
import Page.PlayTimeTrial.Decoders as Decoders
import Update.Utils exposing (..)
import ServerApi
import Game.Models exposing (defaultGame, GameState)
import Game.Steps as Steps
import Game.Outputs as Output
import Game.Inputs as Input
import Task exposing (Task)
import WebSocket
import AnimationFrame
import Keyboard.Extra as Keyboard
import Window
import Http


subscriptions : String -> Model -> Sub Msg
subscriptions host model =
    case model.liveTimeTrial of
        DataOk liveTimeTrial ->
            Sub.batch
                [ WebSocket.listen
                    (ServerApi.timeTrialSocket host)
                    Decoders.decodeStringMsg
                , AnimationFrame.times Frame
                , Sub.map KeyboardMsg Keyboard.subscriptions
                , Window.resizes WindowSize
                ]

        _ ->
            Sub.none


mount : Response Model Msg
mount =
    let
        cmd =
            Cmd.batch
                [ load
                , performSucceed WindowSize Window.size
                ]
    in
        res initial cmd


update : Player -> String -> Msg -> Model -> Response Model Msg
update player host msg model =
    case Debug.log "msg" msg of
        Load result ->
            case result of
                Ok ( liveTimeTrial, course ) ->
                    performSucceed (InitGameState course) Time.now
                        |> res { model | liveTimeTrial = DataOk liveTimeTrial }

                Err e ->
                    res { model | liveTimeTrial = DataErr e } Cmd.none

        InitGameState course time ->
            let
                gameState =
                    defaultGame time course player

                newModel =
                    { model | gameState = Just gameState }

                start =
                    Output.sendToTimeTrialServer host Output.StartRace
            in
                res newModel start

        KeyboardMsg keyboardMsg ->
            let
                ( newKeyboard, keyboardCmd ) =
                    Keyboard.update keyboardMsg model.keyboard
            in
                res { model | keyboard = newKeyboard } (Cmd.map KeyboardMsg keyboardCmd)

        WindowSize size ->
            res { model | dims = ( size.width, size.height ) } Cmd.none

        RaceUpdate raceInput ->
            case model.gameState of
                Just gameState ->
                    res
                        { model | gameState = Just (Steps.raceInputStep raceInput gameState) }
                        Cmd.none

                Nothing ->
                    res model Cmd.none

        Frame time ->
            case model.gameState of
                Just gameState ->
                    let
                        gameInput =
                            Input.GameInput
                                (Input.keyboardInput model.keyboard)
                                model.dims

                        newGameState =
                            Steps.frameStep gameInput time gameState

                        serverCmd =
                            Output.sendToTimeTrialServer
                                host
                                (Output.UpdatePlayer (Output.playerOutput gameState))
                    in
                        if time - model.lastPush > 33 then
                            res { model | gameState = Just newGameState, lastPush = time } serverCmd
                        else
                            res { model | gameState = Just newGameState } Cmd.none

                Nothing ->
                    res model Cmd.none

        SetTab tab ->
            res { model | tab = tab } Cmd.none

        StartRace ->
            let
                start =
                    Output.sendToTimeTrialServer host Output.StartRace
            in
                res model start

        ExitRace ->
            let
                -- newModel =
                --   { model | gameState = Maybe.map clearCrossedGates model.gameState }
                escape =
                    Output.sendToTimeTrialServer host Output.EscapeRace
            in
                res model escape

        AddGhost runId player ->
            let
                newGhostRuns =
                    Dict.insert runId player model.ghostRuns

                cmd =
                    Output.sendToTimeTrialServer host (Output.AddGhost runId player)
            in
                res { model | ghostRuns = newGhostRuns } cmd

        RemoveGhost runId ->
            let
                newGhostRuns =
                    Dict.remove runId model.ghostRuns

                cmd =
                    Output.sendToTimeTrialServer host (Output.RemoveGhost runId)
            in
                res { model | ghostRuns = newGhostRuns } cmd

        NoOp ->
            res model Cmd.none


load : Cmd Msg
load =
    (Http.toTask (ServerApi.getLiveTimeTrial Nothing))
        |> Task.andThen loadCourse
        |> Task.attempt Load


loadCourse : LiveTimeTrial -> Task.Task Http.Error ( LiveTimeTrial, Course )
loadCourse liveTimeTrial =
    ServerApi.getCourse liveTimeTrial.track.id
        |> Http.toTask
        |> Task.map (\course -> ( liveTimeTrial, course ))
