module Page.Explore.Update (..) where

import Page.Explore.Model exposing (..)
import Task exposing (Task, succeed, andThen)
import Task.Extra exposing (delay)
import Time exposing (second)
import Response exposing (..)
import Effects exposing (Effects, Never, none, map, task)
import Model
import Model.Shared exposing (..)
import Update.Utils as Utils
import ServerApi


addr : Signal.Address Action
addr =
  Utils.pageAddr Model.ExploreAction


mount : ( Model, Effects Action )
mount =
  res initial none


update : Action -> Model -> Response Model Action
update action model =
  case action of
    NoOp ->
      res model none
