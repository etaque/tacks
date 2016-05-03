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


mount : ( Model, Effects Action )
mount =
  taskRes initial loadDrafts


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    DraftsResult result ->
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

    SetDraftName name ->
      res { model | name = name } none

    SelectTrack maybeTrack ->
      res { model | selectedTrack = maybeTrack } none

    CreateDraft ->
      taskRes model (Task.map CreateDraftResult (ServerApi.createTrack model.name))

    CreateDraftResult result ->
      case result of
        Ok track ->
          res model (Utils.redirect (Route.EditTrack track.id) |> Utils.always NoOp)

        Err formErrors ->
          -- TODO
          res model none

    ConfirmDeleteDraft id ->
      let
        newConfirm =
          if Just id == model.confirmDelete then
            Nothing
          else
            Just id
      in
        res { model | confirmDelete = newConfirm } none

    DeleteDraft id ->
      taskRes model (deleteDraft id)

    DeleteDraftResult result ->
      case result of
        Ok id ->
          res { model | tracks = List.filter (\t -> t.id /= id) model.tracks } none

        Err _ ->
          res model none

    NoOp ->
      res model none


loadDrafts : Task Never Action
loadDrafts =
  ServerApi.getDrafts
    |> Task.map DraftsResult


deleteDraft : String -> Task Never Action
deleteDraft id =
  ServerApi.deleteDraft id
    |> Task.map DeleteDraftResult
