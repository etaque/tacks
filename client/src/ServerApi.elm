module ServerApi where

import Http
import Task exposing (Task, andThen)
import Json.Decode as Json
import Json.Encode as JsEncode

import Models exposing (..)
import Decoders exposing (..)


-- GET

getPlayer : String -> Task Http.Error Player
getPlayer handle =
  Http.get playerDecoder ("/api/players/" ++ handle)

getLiveStatus : Task Http.Error LiveStatus
getLiveStatus =
  Http.get liveStatusDecoder "/api/liveStatus"

getTrack : String -> Task Http.Error Track
getTrack slug =
  Http.get trackDecoder ("/api/track/" ++ slug)

getLiveTrack : String -> Task Http.Error LiveTrack
getLiveTrack slug =
  Http.get liveTrackDecoder ("/api/liveTrack/" ++ slug)


-- POST

postHandle : String -> Task Http.Error Player
postHandle handle =
  JsEncode.object
    [ ("handle", JsEncode.string handle) ]
    |> postJson playerDecoder "/api/setHandle"

postRegister : String -> String -> String -> Task Http.Error Player
postRegister email handle password =
  JsEncode.object
    [ ("email", JsEncode.string email)
    , ("handle", JsEncode.string handle)
    , ("password", JsEncode.string password)
    ]
    |> postJson playerDecoder "/api/register"

postLogin : String -> String -> Task Http.Error Player
postLogin email password =
  JsEncode.object
    [ ("email", JsEncode.string email)
    , ("password", JsEncode.string password)
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
