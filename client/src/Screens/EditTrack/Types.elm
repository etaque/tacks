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
  { grid : Grid
  , upwind : Gate
  , downwind : Gate
  , center : Point
  , dims : Dims
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
  | Save
  | NoOp

