module Screens.EditTrack.Types where

import Models exposing (..)

import DragAndDrop exposing (MouseEvent(..))


type alias Screen =
  { track : Maybe Track
  , editor : Maybe Editor
  , notFound : Bool
  , dims : Dims
  }

initial : Dims -> Screen
initial dims =
  { track = Nothing
  , editor = Nothing
  , notFound = False
  , dims = dims
  }

type alias Editor =
  { course : Course
  , center : Point
  , courseDims : Dims
  , mode : Mode
  , altMove : Bool
  , name : String
  , saving : Bool
  }

type Mode
  = CreateTile TileKind
  | Erase
  | Watch

realMode : Editor -> Mode
realMode {mode, altMove} =
  if altMove then Watch else mode

type Action
  = LoadTrack (Result () Track)
  | MouseAction MouseEvent
  | SetMode Mode
  | AltMoveMode Bool
  | FormAction FormUpdate
  | SetName String
  | Save
  | SaveResult (FormResult Track)
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

modeName : Mode -> (String, String)
modeName mode =
  case mode of
    CreateTile Water -> ("w", "Water")
    CreateTile Grass -> ("g", "Grass")
    CreateTile Rock -> ("r", "Rock")
    Erase -> ("s", "Sand")
    Watch -> ("m", "Move (press SHIFT for temporary move mode)")
