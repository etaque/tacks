module Screens.ListDrafts.Updates where

import Effects exposing (Effects, Never, none)
import Task exposing (Task)

import AppTypes exposing (..)
import Models exposing (..)
import ServerApi
import Routes

import Screens.ListDrafts.Types exposing (..)
import Screens.UpdateUtils as Utils


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
          staticRes { screen | drafts = drafts}
        Err _ ->
          staticRes screen

    SetDraftName name ->
      staticRes { screen | name = name }

    CreateDraft ->
      taskRes screen (Task.map CreateDraftResult (ServerApi.createTrack screen.name))

    CreateDraftResult result ->
      case result of
        Ok track ->
          res screen (Utils.redirect (Routes.EditTrack track.id) |> Utils.always NoOp)
        Err formErrors ->
          -- TODO
          staticRes screen

    ConfirmDeleteDraft track ->
      let
        newConfirm = if Just track == screen.confirmDelete then Nothing else Just track
      in
        staticRes { screen | confirmDelete = newConfirm }

    DeleteDraft id ->
      taskRes screen (deleteDraft id)

    DeleteDraftResult result ->
      case result of
        Ok id ->
          staticRes { screen | drafts = List.filter (\t -> t.id /= id) screen.drafts }
        Err _ ->
          staticRes screen

    NoOp ->
      staticRes screen

loadDrafts : Task Never Action
loadDrafts =
  ServerApi.getDrafts
    |> Task.map DraftsResult

deleteDraft : String -> Task Never Action
deleteDraft id =
  ServerApi.deleteDraft id
    |> Task.map DeleteDraftResult
