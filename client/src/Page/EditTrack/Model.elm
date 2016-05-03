module Page.EditTrack.Model (..) where

import Model.Shared exposing (..)
import Constants
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
  { tab : Tab
  , currentGate : Maybe Int
  , course : Course
  , center : Point
  , mode : Mode
  , altMove : Bool
  , name : String
  , saving : Bool
  , confirmPublish : Bool
  }


type Tab
  = GatesTab
  | WindTab
  | GustsTab


initialEditor : Track -> Editor
initialEditor track =
  { tab = GatesTab
  , currentGate = Nothing
  , course = track.course
  , center = ( 0, 0 )
  , mode = CreateTile Water
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
realMode { mode, altMove } =
  if altMove then
    Watch
  else
    mode


type Action
  = LoadTrack (Result () Track)
  | MouseAction MouseEvent
  | SetMode Mode
  | AltMoveMode Bool
  | FormAction FormAction
  | SetTab Tab
  | SetName String
  | Save Bool
  | SaveResult Bool (FormResult Track)
  | ConfirmPublish
  | Publish
  | NoOp


type FormAction
  = AddGate
  | SetGateCenterX Int Int
  | SetGateCenterY Int Int
  | SetGateWidth Int Int
  | SetGateOrientation Int Orientation
  | RemoveGate Int
  | SelectGate Int
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
  ( w - Constants.sidebarWidth, h - Constants.toolbarHeight )
