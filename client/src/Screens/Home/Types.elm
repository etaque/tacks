module Screens.Home.Types where

import Models exposing (..)


type alias Screen =
  { handle : String
  , liveStatus : LiveStatus
  }


initial : Player -> Screen
initial player =
  { handle = Maybe.withDefault "" player.handle
  , liveStatus = { liveTracks = [], onlinePlayers = [] }
  }

type Action
  = SetLiveStatus (Result () LiveStatus)
  | SetHandle String
  | SubmitHandle
  | SubmitHandleResult (FormResult Player)
  | NoOp

