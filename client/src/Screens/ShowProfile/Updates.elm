module Screens.ShowProfile.Updates where

import Effects exposing (Effects, Never, none)

import AppTypes exposing (..)
import Models exposing (..)
import Screens.ShowProfile.Types exposing (..)
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr ShowProfileAction


mount : Player -> Response Screen Action
mount player =
  staticRes (initial player)


update : Action -> Screen -> Response Screen Action
update action screen =
  case action of

    NoOp ->
      staticRes screen
