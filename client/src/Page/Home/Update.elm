module Page.Home.Update exposing (..)

import Response exposing (..)
import Dialog
import Page.Home.Model exposing (..)
import ServerApi
import CoreExtra


mount : Model -> Response Model Msg
mount model =
  res model loadRaceReports


update : Msg -> Model -> Response Model Msg
update msg model =
  case msg of
    SetRaceReports result ->
      let
        raceReports =
          Result.withDefault [] result
      in
        res { model | raceReports = raceReports } Cmd.none

    ShowDialog content ->
      Dialog.taggedOpen DialogMsg { model | showDialog = content }

    DialogMsg a ->
      Dialog.taggedUpdate DialogMsg a model

    NoOp ->
      res model Cmd.none


loadRaceReports : Cmd Msg
loadRaceReports =
  ServerApi.getRaceReports Nothing
    |> CoreExtra.performSucceed SetRaceReports
