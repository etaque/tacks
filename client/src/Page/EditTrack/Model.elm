module Page.EditTrack.Model (..) where

import Model.Shared exposing (..)
import Constants exposing (sidebarWidth)
import Drag exposing (MouseEvent(..))


-- import Form exposing (Form)
-- import Form.Validate exposing (..)


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
  , hoverToolbar : Bool
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
      { name = True
      , surface = True
      , gates = False
      , wind = False
      , gusts = False
      }
  , hoverToolbar = False
  , course =
      track.course
      -- , courseForm = initialCourseForm track.course
  , center = ( 0, 0 )
  , mode = CreateTile Water
  , altMove = False
  , name = track.name
  , saving = False
  , confirmPublish = False
  }



-- initialCourseForm : Form () Course
-- initialCourseForm =
--   let
--     fields = []
--   in
--     Form.initial fields validate
-- validate : Course -> Validation () Course
-- validate course =
--   form7
--     Course
--     (get "start" validateGate)
--     (get "gates" (list validateGate))
--     (get "grid")


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
realMode { mode, altMove } =
  if altMove then
    Watch
  else
    mode


type Action
  = LoadTrack (Result () Track)
  | MouseAction MouseEvent
  | HoverToolbar Bool
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
  = SetStartCenterX Int
  | SetStartCenterY Int
  | SetStartWidth Int
  | SetStartOrientation Orientation
  | AddGate
  | SetGateCenterX Int Int
  | SetGateCenterY Int Int
  | SetGateWidth Int Int
  | SetGateOrientation Int Orientation
  | RemoveGate Int
  | UpdateGustGen (GustGenerator -> GustGenerator)
  | SetWindSpeed Int
  | SetWindW1 Int
  | SetWindA1 Int
  | SetWindW2 Int
  | SetWindA2 Int


modeName : Mode -> ( String, String )
modeName mode =
  case mode of
    CreateTile Water ->
      ( "w", "Water" )

    CreateTile Grass ->
      ( "g", "Grass" )

    CreateTile Rock ->
      ( "r", "Rock" )

    Erase ->
      ( "s", "Sand" )

    Watch ->
      ( "m", "Move" )


getCourseDims : Dims -> Dims
getCourseDims ( w, h ) =
  ( w - sidebarWidth, h )
