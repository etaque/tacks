module Page.EditTrack.Model exposing (..)

import Model.Shared exposing (..)
import Constants
import Mouse exposing (Position)


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
  , drag : Maybe Position
  , mode : Mode
  , windSimDuration : WindSimDuration
  , altMove : Bool
  , name : String
  , saving : Bool
  , confirmPublish : Bool
  }


type Tab
  = GatesTab
  | WindTab
  | GustsTab


initialEditor : Track -> Course -> Editor
initialEditor track course =
  { tab = GatesTab
  , currentGate = Nothing
  , course = course
  , center = ( 0, 0 )
  , drag = Nothing
  , mode = CreateTile Water
  , windSimDuration = TenMin
  , altMove = False
  , name = track.name
  , saving = False
  , confirmPublish = False
  }


type Mode
  = CreateTile TileKind
  | Erase
  | Watch


type WindSimDuration
  = TenMin
  | OneHour


realMode : Editor -> Mode
realMode { mode, altMove } =
  if altMove then
    Watch
  else
    mode


type Msg
  = LoadTrack (Result () Track) (Result () Course)
  | SetMode Mode
  | AltMoveMode Bool
  | FormMsg FormMsg
  | MouseMsg MouseMsg
  | SetTab Tab
  | SetName String
  | Save Bool
  | SaveResult Bool (FormResult Track)
  | ConfirmPublish
  | Publish
  | NoOp


type MouseMsg
  = DragStart Position
  | DragAt Position
  | DragEnd Position


type FormMsg
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
  | SetWindSimDuration WindSimDuration


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
