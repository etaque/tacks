module ServerApi where

import Http
import Task exposing (Task, andThen)
import Json.Decode as Json
import Json.Encode as JsEncode

import Forms.Model exposing (..)
import Inputs exposing (..)
import Game exposing (Player)
import Decoders exposing (playerDecoder)


-- GET

getPlayer : String -> Task Http.Error Player
getPlayer id =
  Http.get playerDecoder ("/api/players/" ++ id)


getRaceCourse : String -> Task Http.Error Player
getRaceCourse id =
  Http.get playerDecoder ("/api/players/" ++ id)


-- POST

postHandle : SetHandleForm -> Task Http.Error Player
postHandle f =
  JsEncode.object
    [ ("handle", JsEncode.string f.handle) ]
    |> postJson playerDecoder "/api/setHandle"

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

jsonToBody : JsEncode.Value -> Http.Body
jsonToBody jsValue =
  Http.string (JsEncode.encode 0 jsValue)

postJson : Json.Decoder a -> String -> JsEncode.Value -> Task Http.Error a
postJson decoder url jsonBody =
  Http.send Http.defaultSettings
    { verb = "POST"
    , headers = [ ("Content-Type", "application/json") ]
    , url = url
    , body = jsonToBody jsonBody
    }
    |> Http.fromJson decoder
