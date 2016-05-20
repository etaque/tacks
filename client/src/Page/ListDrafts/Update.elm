module Page.ListDrafts.Update exposing (..)

import Task exposing (Task)
import Response exposing (..)
import ServerApi
import Route
import Page.ListDrafts.Model exposing (..)
import CoreExtra exposing (..)
import Location


mount : Model -> Res Model Msg
mount model =
  res model loadDrafts


update : Msg -> Model -> Res Model Msg
update msg model =
  case msg of
    ListResult result ->
      case result of
        Ok tracks ->
          res { model | tracks = tracks } Cmd.none

        Err _ ->
          res model Cmd.none

    ToggleCreationForm ->
      let
        newShow =
          not model.showCreationForm
      in
        res { model | showCreationForm = newShow } Cmd.none

    SetName name ->
      res { model | name = name } Cmd.none

    Select maybeTrack ->
      res { model | selectedTrack = maybeTrack } Cmd.none

    Create ->
      res model (Task.perform never CreateResult (ServerApi.createTrack model.name))

    CreateResult result ->
      case result of
        Ok track ->
          res model (Location.navigate (Route.EditTrack track.id))

        Err formErrors ->
          -- TODO
          res model Cmd.none

    ConfirmPublish b ->
      res { model | confirmPublish = b } Cmd.none

    Publish id ->
      res model (publish id)

    PublishResult result ->
      case result of
        Ok track ->
          res model (Location.navigate (Route.PlayTrack track.id))

        Err errors ->
          -- TODO
          res model Cmd.none

    ConfirmDelete b ->
      res { model | confirmDelete = b } Cmd.none

    Delete id ->
      res model (deleteDraft id)

    DeleteResult result ->
      case result of
        Ok id ->
          res { model | tracks = List.filter (\t -> t.id /= id) model.tracks } Cmd.none

        Err _ ->
          res model Cmd.none

    NoOp ->
      res model Cmd.none


loadDrafts : Cmd Msg
loadDrafts =
  ServerApi.getUserTracks
    |> Task.perform never ListResult


publish : String -> Cmd Msg
publish id =
  ServerApi.publishTrack id
    |> Task.perform never PublishResult


deleteDraft : String -> Cmd Msg
deleteDraft id =
  ServerApi.deleteDraft id
    |> Task.perform never DeleteResult
