module Page.Admin.Model exposing (..)

import Json.Decode as Json exposing (..)
import Model.Shared exposing (..)
import Decoders exposing (..)
import Page.Admin.Route exposing (..)
import Http


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
    map4
        AdminData
        (field "tracks" (list trackDecoder))
        (field "users" (list userDecoder))
        (field "reports" (list raceReportDecoder))
        (field "timeTrials" (list timeTrialDecoder))


userDecoder : Decoder User
userDecoder =
    map7
        User
        (field "id" string)
        (field "email" string)
        (field "handle" string)
        (maybe (field "status" string))
        (maybe (field "avatarId" string))
        (field "vmgMagnet" int)
        (field "creationTime" float)


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
    | RefreshDataResult (Result Http.Error AdminData)
    | DeleteTrack String
    | DeleteTrackResult (FormResult String)
    | DeleteTimeTrial String
    | DeleteTimeTrialResult (FormResult String)
    | NoOp
