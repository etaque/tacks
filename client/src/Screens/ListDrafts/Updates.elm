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
  initial &! loadDrafts


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    DraftsResult result ->
      case result of
        Ok drafts ->
          { screen | drafts = drafts} &: none
        Err _ ->
          screen &: none

    SetDraftName name ->
      { screen | name = name } &: none

    CreateDraft ->
      screen &! (Task.map CreateDraftResult (ServerApi.createTrack screen.name))

    CreateDraftResult result ->
      case result of
        Ok track ->
          screen &: (Utils.redirect (Routes.EditTrack track.id) |> Utils.always NoOp)
        Err formErrors -> -- TODO
          screen &: none

    DeleteDraft id ->
      screen &! (deleteDraft id)

    DeleteDraftResult result ->
      case result of
        Ok id ->
          { screen | drafts = List.filter (\t -> t.id /= id) screen.drafts } &: none
        Err _ ->
          screen &: none

    NoOp ->
      screen &: none

loadDrafts : Task Never Action
loadDrafts =
  ServerApi.getDrafts
    |> Task.map DraftsResult

deleteDraft : String -> Task Never Action
deleteDraft id =
  ServerApi.deleteDraft id
    |> Task.map DeleteDraftResult
