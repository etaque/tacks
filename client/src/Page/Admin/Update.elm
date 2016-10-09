module Page.Admin.Update exposing (..)

import Response exposing (..)
import Page.Admin.Model exposing (..)
import ServerApi exposing (getJson, postJson)
import Update.Utils exposing (..)
import Task


mount : Response Model Msg
mount =
    res initial refreshData


update : Msg -> Model -> Response Model Msg
update msg model =
    case msg of
        RefreshData ->
            res model refreshData

        RefreshDataResult result ->
            let
                { tracks, users, reports, timeTrials } =
                    Result.withDefault (AdminData [] [] [] []) result

                newModel =
                    { model
                        | tracks = tracks
                        , users = users
                        , reports = reports
                        , timeTrials = timeTrials
                    }
            in
                res newModel Cmd.none

        DeleteTimeTrial id ->
            ServerApi.deleteTimeTrial id
                |> Task.toResult
                |> performSucceed DeleteTimeTrialResult
                |> res model

        DeleteTimeTrialResult result ->
            case result of
                Ok id ->
                    -- TODO
                    res model Cmd.none

                Err _ ->
                    res model Cmd.none

        DeleteTrack id ->
            ServerApi.deleteDraft id
                |> Task.toResult
                |> performSucceed DeleteTrackResult
                |> res model

        DeleteTrackResult result ->
            case result of
                Ok id ->
                    res { model | tracks = List.filter (\t -> t.id /= id) model.tracks } Cmd.none

                Err _ ->
                    res model Cmd.none

        NoOp ->
            res model Cmd.none


refreshData : Cmd Msg
refreshData =
    getJson adminDataDecoder "/api/admin"
        |> performSucceed RefreshDataResult
