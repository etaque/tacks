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
  Utils.screenAddr ListDraftsAction


mount : (Screen, Effects Action)
mount =
  taskRes initial loadDrafts


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    DraftsResult result ->
      case result of
        Ok drafts ->
          res { screen | drafts = drafts} none
        Err _ ->
          res screen none

    SetDraftName name ->
      res { screen | name = name } none

    CreateDraft ->
      taskRes screen (Task.map CreateDraftResult (ServerApi.createTrack screen.name))

    CreateDraftResult result ->
      case result of
        Ok track ->
          res screen (Utils.redirect (Route.EditTrack track.id) |> Utils.always NoOp)
        Err formErrors ->
          -- TODO
          res screen none

    ConfirmDeleteDraft track ->
      let
        newConfirm = if Just track == screen.confirmDelete then Nothing else Just track
      in
        res { screen | confirmDelete = newConfirm } none

    DeleteDraft id ->
      taskRes screen (deleteDraft id)

    DeleteDraftResult result ->
      case result of
        Ok id ->
          res { screen | drafts = List.filter (\t -> t.id /= id) screen.drafts } none
        Err _ ->
          res screen none

    NoOp ->
      res screen none

loadDrafts : Task Never Action
loadDrafts =
  ServerApi.getDrafts
    |> Task.map DraftsResult

deleteDraft : String -> Task Never Action
deleteDraft id =
  ServerApi.deleteDraft id
    |> Task.map DeleteDraftResult
