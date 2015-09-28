module Screens.EditTrack.Types where

import Models exposing (..)
import Game.Geo exposing (..)

import DragAndDrop exposing (MouseEvent(..))

type alias Screen =
  { track : Maybe Track
  , editor : Maybe Editor
  , notFound : Bool
  , dims : Dims
  }

type alias Editor =
  { course : Course
  , center : Point
  , courseDims : Dims
  , mode : Mode
  }

type Mode
  = CreateTile TileKind
  | Erase
  | Watch

type Action
  = SetTrack Track
  | TrackNotFound
  | MouseAction MouseEvent
  | NextTileKind
  | EscapeMode
  | FormAction FormUpdate
  | Save
  | NoOp

type FormUpdate
  = SetDownwindY Int
  | SetUpwindY Int
  | SetGateWidth Int
  | SetLaps Int
  | SetGustInterval Int
  | CreateGustDef
  | RemoveGustDef Int
  | SetGustAngle Int Int
  | SetGustSpeed Int Int
  | SetGustRadius Int Int
  | SetWindW1 Int
  | SetWindA1 Int
  | SetWindW2 Int
  | SetWindA2 Int

