module Screens.ShowProfile.Updates where


import AppTypes exposing (..)
import Models exposing (..)
import Screens.ShowProfile.Types exposing (..)


addr : Signal.Address Action
addr =
  Signal.forwardTo appActionsMailbox.address (ShowProfileAction >> ScreenAction)

type alias Update = AppTypes.ScreenUpdate Screen


mount : Player -> Update
mount player =
  let
    initial = { player = player }
  in
    local initial


update : Action -> Screen -> Update
update action screen =
  case action of

    _ ->
      local screen
