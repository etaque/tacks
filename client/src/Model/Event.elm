module Model.Event exposing (..)

import Model.Shared exposing (..)
import Route exposing (Route)


type Event
  = SetPlayer Player
  | MountRoute Route Route
