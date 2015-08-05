module ServerApi where

import Http
import Task exposing (Task, andThen)
import Json.Decode as Json
import Json.Encode as JsEncode

import Forms.Model exposing (..)
import State exposing (..)
import Game exposing (Player)
import Decoders exposing (..)


-- GET

getPlayer : String -> Task Http.Error Player
getPlayer handle =
  Http.get playerDecoder ("/api/players/" ++ handle)

getLiveStatus : Task Http.Error LiveStatus
getLiveStatus =
  Http.get liveStatusDecoder "/api/liveStatus"

getRaceCourse : String -> Task Http.Error RaceCourse
getRaceCourse slug =
  Http.get raceCourseDecoder ("/api/raceCourse/" ++ slug)

getRaceCourseStatus : String -> Task Http.Error RaceCourseStatus
getRaceCourseStatus slug =
  Http.get raceCourseStatusDecoder ("/api/raceCourseStatus/" ++ slug)


-- POST

postHandle : SetHandleForm -> Task Http.Error Player
postHandle f =
  JsEncode.object
    [ ("handle", JsEncode.string f.handle) ]
    |> postJson playerDecoder "/api/setHandle"

postRegister : RegisterForm -> Task Http.Error Player
postRegister f =
  JsEncode.object
    [ ("email", JsEncode.string f.email)
    , ("handle", JsEncode.string f.handle)
    , ("password", JsEncode.string f.password)
    ]
    |> postJson playerDecoder "/api/register"

postLogin : LoginForm -> Task Http.Error Player
postLogin f =
  JsEncode.object
    [ ("email", JsEncode.string f.email)
    , ("password", JsEncode.string f.password)
    ]
    |> postJson playerDecoder "/api/login"

postLogout : Task Http.Error Player
postLogout =
  postJson playerDecoder "/api/logout" JsEncode.null


-- Tooling

postJson : Json.Decoder a -> String -> JsEncode.Value -> Task Http.Error a
postJson decoder url jsonBody =
  Http.send Http.defaultSettings
    { verb = "POST"
    , headers = [ ("Content-Type", "application/json") ]
    , url = url
    , body = Http.string (JsEncode.encode 0 jsonBody)
    }
    |> Http.fromJson decoder
