module Page.PlayTimeTrial.Update exposing (..)

import Time exposing (millisecond, second)
import Time exposing (Time)
import Result exposing (Result(Ok, Err))
import Response exposing (..)
import Model.Shared exposing (..)
import Page.PlayTimeTrial.Model as Model exposing (..)
import Page.PlayTimeTrial.Decoders as Decoders
import ServerApi
import Game.Shared exposing (defaultGame, GameState)
import Game.Update as Game
import Game.Output as Output
import Game.Msg exposing (..)
import Task exposing (Task)
import WebSocket
import Http
import List.Extra as ListExtra
import Dialog


subscriptions : String -> LiveStatus -> Model -> Sub Msg
subscriptions host liveStatus model =
    case liveStatus.liveTimeTrial of
        Just liveTimeTrial ->
            Sub.batch
                [ WebSocket.listen
                    (ServerApi.timeTrialSocket host)
                    Decoders.decodeStringMsg
                , Sub.map GameMsg (Game.subscriptions model)
                , Sub.map DialogMsg (Dialog.subscriptions model.dialog)
                ]

        _ ->
            Sub.none


mount : LiveStatus -> Response Model Msg
mount liveStatus =
    case liveStatus.liveTimeTrial of
        Just ltt ->
            Cmd.batch [ loadCourse ltt, Cmd.map GameMsg Game.mount ]
                |> res initial

        Nothing ->
            res initial Cmd.none


update : LiveStatus -> Player -> String -> Msg -> Model -> Response Model Msg
update liveStatus player host msg model =
    case msg of
        LoadCourse result ->
            case result of
                Ok course ->
                    Task.perform (InitGameState course) Time.now
                        |> res model

                Err e ->
                    -- TODO handle err
                    res model Cmd.none

        InitGameState course time ->
            let
                gameState =
                    defaultGame time course player

                newModel =
                    { model | gameState = Just gameState }

                startCmd =
                    Output.sendToTimeTrialServer host Output.StartRace

                ghostsCmd =
                    Maybe.map (electGhosts player) liveStatus.liveTimeTrial
                        |> Maybe.withDefault Cmd.none
            in
                res newModel (Cmd.batch [ startCmd, ghostsCmd ])

        GameMsg gameMsg ->
            Game.update player (Output.sendToTimeTrialServer host) gameMsg model
                |> mapCmd GameMsg

        ShowContext b ->
            res { model | showContext = b } Cmd.none

        ShowDialog kind ->
            Dialog.taggedOpen DialogMsg { model | dialogKind = Just kind }
                |> toResponse

        DialogMsg dialogMsg ->
            Dialog.taggedUpdate DialogMsg dialogMsg model
                |> toResponse

        Model.NoOp ->
            res model Cmd.none


loadCourse : LiveTimeTrial -> Cmd Msg
loadCourse liveTimeTrial =
    ServerApi.getCourse liveTimeTrial.track.id
        |> Http.send LoadCourse


maxGhosts : Int
maxGhosts =
    5


electGhosts : Player -> LiveTimeTrial -> Cmd Msg
electGhosts player { meta } =
    let
        playerIndex =
            ListExtra.findIndex (\r -> r.player.id == player.id) meta.rankings

        runs =
            case playerIndex of
                Just i ->
                    let
                        faster =
                            meta.rankings
                                |> List.take (i + 1)
                                |> List.reverse
                                |> List.take maxGhosts

                        slower =
                            meta.rankings
                                |> List.drop i
                    in
                        List.take maxGhosts (faster ++ slower)

                Nothing ->
                    meta.rankings
                        |> List.reverse
                        |> List.take maxGhosts
    in
        runs
            |> List.map (\r -> AddGhost r.runId r.player)
            |> List.map (Task.succeed >> (Task.perform identity))
            |> Cmd.batch
            |> Cmd.map GameMsg
