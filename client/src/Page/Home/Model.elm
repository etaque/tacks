module Page.Home.Model where

import Model.Shared exposing (..)


type alias Model =
  { handle : String
  , liveStatus : LiveStatus
  , trackFocus : Maybe TrackId
  }


initial : Player -> Model
initial player =
  { handle = Maybe.withDefault "" player.handle
  , liveStatus = { liveTracks = [], onlinePlayers = [] }
  , trackFocus = Nothing
  }

type Action
  = SetLiveStatus (Result () LiveStatus)
  | SetHandle String
  | FocusTrack (Maybe TrackId)
  | SubmitHandle
  | SubmitHandleResult (FormResult Player)
  | NoOp

