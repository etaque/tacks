module Screens.Home.Types where

import Models exposing (..)


type alias Screen =
  { handle : String
  , liveStatus : LiveStatus
  }


type Action
  = Load
  | SetLiveStatus LiveStatus
  | SetHandle String
  | SubmitHandle
  | SubmitHandleSuccess Player
  | NoOp

