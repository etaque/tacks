module Page.Home.Model (..) where

import Model.Shared exposing (..)


type alias Model =
  { handle : String
  , liveStatus : LiveStatus
  , trackFocus : Maybe TrackId
  , raceReports : List RaceReport
  }


initial : Player -> Model
initial player =
  { handle = Maybe.withDefault "" player.handle
  , liveStatus = { liveTracks = [], onlinePlayers = [] }
  , trackFocus = Nothing
  , raceReports = []
  }


type Action
  = SetLiveStatus (Result () LiveStatus)
  | SetRaceReports (Result () (List RaceReport))
  | SetHandle String
  | FocusTrack (Maybe TrackId)
  | SubmitHandle
  | SubmitHandleResult (FormResult Player)
  | NoOp
