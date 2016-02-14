module Page.Admin.Model where

import Json.Decode as Json exposing (..)

import Model.Shared exposing (Id, Track, FormResult)
import Decoders exposing (trackDecoder)
import Page.Admin.Route exposing (..)


type alias Model =
  { tracks : List Track
  , users : List User
  }


type alias User =
  { id : Id
  , email : String
  , handle : String
  , status : Maybe String
  , avatarId : Maybe String
  , vmgMagnet : Int
  , creationTime : Float
  }


type alias AdminData =
  { tracks : List Track
  , users : List User
  }


adminDataDecoder : Decoder AdminData
adminDataDecoder =
  object2 AdminData
    ("tracks" := list trackDecoder)
    ("users" := list userDecoder)


userDecoder : Decoder User
userDecoder =
  object7 User
    ("id" := string)
    ("email" := string)
    ("handle" := string)
    (maybe ("status" := string))
    (maybe ("avatarId" := string))
    ("vmgMagnet" := int)
    ("creationTime" := float)


initialRoute : Route
initialRoute =
  Dashboard


initial : Model
initial =
  { tracks = []
  , users = []
  }


type Action
  = RefreshData
  | RefreshDataResult (Result () AdminData)
  | DeleteTrack String
  | DeleteTrackResult (FormResult String)
  | NoOp

