module Page.ListDrafts.Update (..) where

import Effects exposing (Effects, Never, none)
import Task exposing (Task)
import Response exposing (..)
import Model
import Model.Shared exposing (..)
import ServerApi
import Route
import Page.ListDrafts.Model exposing (..)
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr Model.ListDraftsAction


mount : Model -> ( Model, Effects Action )
mount model =
  taskRes model loadDrafts


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    ListResult result ->
      case result of
        Ok tracks ->
          res { model | tracks = tracks } none

        Err _ ->
          res model none

    ToggleCreationForm ->
      let
        newShow =
          not model.showCreationForm
      in
        res { model | showCreationForm = newShow } none

    SetName name ->
      res { model | name = name } none

    Select maybeTrack ->
      res { model | selectedTrack = maybeTrack } none

    Create ->
      taskRes model (Task.map CreateResult (ServerApi.createTrack model.name))

    CreateResult result ->
      case result of
        Ok track ->
          res model (Utils.redirect (Route.EditTrack track.id) |> Utils.always NoOp)

        Err formErrors ->
          -- TODO
          res model none

    ConfirmPublish b ->
      res { model | confirmPublish = b } none

    Publish id ->
      taskRes model (publish id)

    PublishResult result ->
      case result of
        Ok track ->
          Effects.map (\_ -> NoOp) (Utils.redirect (Route.PlayTrack track.id))
            |> res model

        Err errors ->
          -- TODO
          res model none

    ConfirmDelete b ->
      res { model | confirmDelete = b } none

    Delete id ->
      taskRes model (deleteDraft id)

    DeleteResult result ->
      case result of
        Ok id ->
          res { model | tracks = List.filter (\t -> t.id /= id) model.tracks } none

        Err _ ->
          res model none

    NoOp ->
      res model none


loadDrafts : Task Never Action
loadDrafts =
  ServerApi.getUserTracks
    |> Task.map ListResult


publish : String -> Task Never Action
publish id =
  ServerApi.publishTrack id
    |> Task.map PublishResult


deleteDraft : String -> Task Never Action
deleteDraft id =
  ServerApi.deleteDraft id
    |> Task.map DeleteResult
