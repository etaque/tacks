module Screens.ShowProfile.Update where

import Effects exposing (Effects, Never, none)
import Response exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Screens.ShowProfile.Model exposing (..)
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr ShowProfileAction


mount : Player -> Response Screen Action
mount player =
  res (initial player) none


update : Action -> Screen -> Response Screen Action
update action screen =
  case action of

    NoOp ->
      res screen none
