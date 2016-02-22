module Page.ShowProfile.Update where

import Effects exposing (Effects, Never, none)
import Response exposing (..)

import Model.Shared exposing (..)
import Page.ShowProfile.Model exposing (..)
import Update.Utils as Utils


mount : Player -> Response Model Action
mount player =
  res (initial player) none


update : Action -> Model -> Response Model Action
update action model =
  case action of

    NoOp ->
      res model none
