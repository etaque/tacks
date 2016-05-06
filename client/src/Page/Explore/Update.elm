module Page.Explore.Update (..) where

import Page.Explore.Model exposing (..)
import Response exposing (..)
import Dialog
import Effects exposing (Effects, Never, none, map, task)
import Model
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr Model.ExploreAction


mount : ( Model, Effects Action )
mount =
  res initial none


update : Action -> Model -> Response Model Action
update action model =
  case action of
    ShowTrackRanking liveTrack ->
      Dialog.taggedOpen DialogAction { model | showTrackRanking = Just liveTrack }

    DialogAction a ->
      Dialog.taggedUpdate DialogAction a model

    NoOp ->
      res model none
