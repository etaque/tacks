module Transition (Transition, WithTransition, Action, init, step, applyInit, applyStep, value, empty) where

import Time exposing (Time)
import Effects exposing (Effects)
import Animation exposing (..)


type Transition = T (Maybe Float)
type alias WithTransition model = { model | transition : Transition }

type Action = Init | Start Time | Tick Animation Time


start : Transition
start =
  T (Just 0)

set : Float -> Transition
set =
  T << Just

empty : Transition
empty =
  T Nothing

value : Transition -> Maybe Float
value (T v) =
  v

applyStep : WithTransition model -> (Action -> action) -> Action -> (WithTransition model, Effects action)
applyStep model actionWrapper action =
  let
    (t, fx) = step action
  in
    ({ model | transition = t }, Effects.map actionWrapper fx)

applyInit : WithTransition model -> (Action -> action) -> (WithTransition model, Effects action)
applyInit model actionWrapper =
  applyStep model actionWrapper init

init : Action
init =
  Init

step : Action -> (Transition, Effects Action)
step action =
  case action of

    Init ->
      (start, Effects.tick Start)

    Start time ->
      let
        anim = animation time
          |> duration 200
        fx = Effects.tick (Tick anim)
      in
        (set (animate time anim), fx)

    Tick anim time ->
      if isDone time anim then
        (empty, Effects.none)
      else
        (set (animate time anim), Effects.tick (Tick anim))

