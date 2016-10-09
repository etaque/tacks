module Page.Admin.Model exposing (..)

import Json.Decode as Json exposing (..)
import Model.Shared exposing (..)
import Decoders exposing (..)
import Page.Admin.Route exposing (..)


type alias Model =
    { tracks : List Track
    , users : List User
    , reports : List RaceReport
    , timeTrials : List TimeTrial
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
    , reports : List RaceReport
    , timeTrials : List TimeTrial
    }


adminDataDecoder : Decoder AdminData
adminDataDecoder =
    object4
        AdminData
        ("tracks" := list trackDecoder)
        ("users" := list userDecoder)
        ("reports" := list raceReportDecoder)
        ("timeTrials" := list timeTrialDecoder)


userDecoder : Decoder User
userDecoder =
    object7
        User
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
    , reports = []
    , timeTrials = []
    }


type Msg
    = RefreshData
    | RefreshDataResult (Result () AdminData)
    | DeleteTrack String
    | DeleteTrackResult (HttpResult String)
    | DeleteTimeTrial String
    | DeleteTimeTrialResult (HttpResult String)
    | NoOp
