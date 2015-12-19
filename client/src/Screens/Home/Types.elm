module Screens.Home.Types where

import Models exposing (..)


type alias Screen =
  { handle : String
  , liveStatus : LiveStatus
  , trackFocus : Maybe TrackId
  }


initial : Player -> Screen
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

