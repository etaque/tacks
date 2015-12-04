module Screens.ShowProfile.Updates where

import Effects exposing (Effects, Never, none)

import AppTypes exposing (..)
import Models exposing (..)
import Screens.ShowProfile.Types exposing (..)
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr ShowProfileAction


mount : Player -> (Screen, Effects Action)
mount player =
  initial player &: none


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    NoOp ->
      screen &: none
