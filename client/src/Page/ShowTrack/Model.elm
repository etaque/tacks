module Page.ShowTrack.Model (..) where

import Model.Shared exposing (..)
import Drag exposing (MouseEvent(..))


type alias Model =
  { liveTrack : Maybe LiveTrack
  , notFound : Bool
  , courseControl : CourseControl
  , raceReports : List RaceReport
  }


type alias CourseControl =
  { over : Bool
  , dragging : Bool
  , center : Point
  , scale : Float
  }


initial : Model
initial =
  { liveTrack = Nothing
  , notFound = False
  , courseControl =
      { over = False
      , dragging = False
      , center = ( 0, 0 )
      , scale = 0.5
      }
  , raceReports = []
  }


type Action
  = LiveTrackResult (Result () LiveTrack)
  | RaceReportsResult (Result () (List RaceReport))
  | SetOverCourse Bool
  | MouseAction MouseEvent
  | NoOp
