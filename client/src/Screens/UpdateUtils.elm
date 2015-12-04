module Screens.UpdateUtils where

import Effects exposing (Effects)
import Signal

import Routes
import AppTypes exposing (appActionsAddress)
import Models exposing (..)


redirect : Routes.Route -> Effects ()
redirect route =
  AppTypes.SetPath (Routes.toPath route)
    |> Signal.send appActionsAddress
    |> Effects.task


setPlayer : Player -> Effects ()
setPlayer player =
  AppTypes.SetPlayer player
    |> Signal.send appActionsAddress
    |> Effects.task

always : action -> Effects a -> Effects action
always action effect =
  Effects.map (\_ -> action) effect

screenAddr : (action -> AppTypes.ScreenAction) -> Signal.Address action
screenAddr toScreenAction =
  Signal.forwardTo appActionsAddress (toScreenAction >> AppTypes.ScreenAction)
