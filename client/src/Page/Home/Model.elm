module Page.Home.Model (..) where

import Model.Shared exposing (..)


type alias Model =
  { handle : String
  , trackFocus : Maybe TrackId
  , raceReports : List RaceReport
  }


initial : Player -> Model
initial player =
  { handle = Maybe.withDefault "" player.handle
  , trackFocus = Nothing
  , raceReports = []
  }


type Action
  = SetRaceReports (Result () (List RaceReport))
  | SetHandle String
  | FocusTrack (Maybe TrackId)
  | SubmitHandle
  | SubmitHandleResult (FormResult Player)
  | NoOp
