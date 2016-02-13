module Page.ListDrafts.Update where

import Effects exposing (Effects, Never, none)
import Task exposing (Task)
import Response exposing (..)

import Model exposing (..)
import Model.Shared exposing (..)
import ServerApi
import Route

import Page.ListDrafts.Model exposing (..)
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr ListDraftsAction


mount : (Model, Effects Action)
mount =
  taskRes initial loadDrafts


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of

    DraftsResult result ->
      case result of
        Ok drafts ->
          res { model | drafts = drafts} none
        Err _ ->
          res model none

    SetDraftName name ->
      res { model | name = name } none

    CreateDraft ->
      taskRes model (Task.map CreateDraftResult (ServerApi.createTrack model.name))

    CreateDraftResult result ->
      case result of
        Ok track ->
          res model (Utils.redirect (Route.EditTrack track.id) |> Utils.always NoOp)
        Err formErrors ->
          -- TODO
          res model none

    ConfirmDeleteDraft track ->
      let
        newConfirm = if Just track == model.confirmDelete then Nothing else Just track
      in
        res { model | confirmDelete = newConfirm } none

    DeleteDraft id ->
      taskRes model (deleteDraft id)

    DeleteDraftResult result ->
      case result of
        Ok id ->
          res { model | drafts = List.filter (\t -> t.id /= id) model.drafts } none
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
