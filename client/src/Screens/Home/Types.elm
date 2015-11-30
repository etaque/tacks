module Screens.Home.Types where

import Models exposing (..)


type alias Screen =
  { handle : String
  , liveStatus : LiveStatus
  }


type Action
  = SetLiveStatus LiveStatus
  | SetHandle String
  | SubmitHandle
  | SubmitHandleSuccess Player
  | CreateTrack
  | TrackCreated String

