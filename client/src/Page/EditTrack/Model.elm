module Page.EditTrack.Model where

import Model.Shared exposing (..)
import Constants exposing (sidebarWidth)

import Drag exposing (MouseEvent(..))


type alias Model =
  { track : Maybe Track
  , editor : Maybe Editor
  , notFound : Bool
  }

initial : Model
initial =
  { track = Nothing
  , editor = Nothing
  , notFound = False
  }

type alias Editor =
  { blocks : SideBlocks
  , course : Course
  , center : Point
  , mode : Mode
  , altMove : Bool
  , name : String
  , saving : Bool
  , confirmPublish : Bool
  }

initialEditor : Track -> Editor
initialEditor track =
  { blocks =
    { name = False
    , surface = False
    , gates = False
    , wind = False
    , gusts = False
    }
  , course = track.course
  , center = (0, 0)
  , mode = Watch
  , altMove = False
  , name = track.name
  , saving = False
  , confirmPublish = False
  }

type alias SideBlocks =
  { name : Bool
  , surface : Bool
  , gates : Bool
  , wind : Bool
  , gusts : Bool
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
  | ToggleBlock SideBlock
  | SetName String
  | Save Bool
  | SaveResult Bool (FormResult Track)
  | ConfirmPublish
  | Publish
  | NoOp

type SideBlock
  = Name
  | Surface
  | Gates
  | Wind
  | Gusts

type FormUpdate
  = SetDownwindY Int
  | SetUpwindY Int
  | SetGateWidth Int
  | SetLaps Int
  | UpdateGustGen (GustGenerator -> GustGenerator)
  | SetWindSpeed Int
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

getCourseDims : Dims -> Dims
getCourseDims (w, h) =
  (w - sidebarWidth, h)
