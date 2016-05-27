module Page.Admin.Update exposing (..)

import Response exposing (..)
import Page.Admin.Model exposing (..)
import ServerApi exposing (getJson, postJson)
import Update.Utils exposing (..)


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
        { tracks, users, reports } =
          Result.withDefault (AdminData [] [] []) result
      in
        res { model | tracks = tracks, users = users, reports = reports } Cmd.none

    DeleteTrack id ->
      res model (performSucceed DeleteTrackResult (ServerApi.deleteDraft id))

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
