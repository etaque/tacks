module ServerApi where

import Http exposing (..)
import Task exposing (Task, andThen)
import Json.Decode as Json
import Json.Encode as JsEncode
import Dict exposing (Dict)
import Result exposing (Result(Ok,Err))

import Models exposing (..)
import Decoders exposing (..)
import AppTypes exposing (..)

import Debug

-- GET

type alias GetJsonTask a = Task Never (Result () a)

getPlayer : String -> GetJsonTask Player
getPlayer handle =
  getJson playerDecoder ("/api/players/" ++ handle)

getLiveStatus : GetJsonTask LiveStatus
getLiveStatus =
  getJson liveStatusDecoder "/api/liveStatus"

getTrack : String -> GetJsonTask Track
getTrack slug =
  getJson trackDecoder ("/api/track/" ++ slug)

getLiveTrack : String -> GetJsonTask LiveTrack
getLiveTrack slug =
  getJson liveTrackDecoder ("/api/liveTrack/" ++ slug)

getJson : Json.Decoder a -> String -> GetJsonTask a
getJson decoder path =
  Http.get decoder path
    |> Task.toResult
    |> Task.map (Result.formatError (\_ -> ()))

-- POST

postHandle : String -> Task Never (FormResult Player)
postHandle handle =
  JsEncode.object
    [ ("handle", JsEncode.string handle) ]
    |> postJson playerDecoder "/api/setHandle"

postRegister : String -> String -> String -> Task Never (FormResult Player)
postRegister email handle password =
  JsEncode.object
    [ ("email", JsEncode.string email)
    , ("handle", JsEncode.string handle)
    , ("password", JsEncode.string password)
    ]
    |> postJson playerDecoder "/api/register"

postLogin : String -> String -> Task Never (FormResult Player)
postLogin email password =
  JsEncode.object
    [ ("email", JsEncode.string email)
    , ("password", JsEncode.string password)
    ]
    |> postJson playerDecoder "/api/login"

postLogout : Task Never (FormResult Player)
postLogout =
  postJson playerDecoder "/api/logout" JsEncode.null


-- Tooling

postJson : Json.Decoder a -> String -> JsEncode.Value -> Task Never (FormResult a)
postJson decoder url jsonBody =
  Http.send Http.defaultSettings (jsonRequest url jsonBody)
    |> Task.toResult
    |> Task.map (handleResult decoder)


jsonRequest : String -> JsEncode.Value -> Request
jsonRequest url jsonBody =
  { verb = "POST"
  , headers = [ ("Content-Type", "application/json") ]
  , url = url
  , body = Http.string (JsEncode.encode 0 jsonBody)
  }


handleResult : Json.Decoder a -> Result RawError Response -> FormResult a
handleResult decoder result =
  case result of
    Ok response ->
      handleResponse decoder response
    Err _ ->
      Err serverError


handleResponse : Json.Decoder a -> Response -> FormResult a
handleResponse decoder response =
  case 200 <= response.status && response.status < 300 of
    False ->
      case (response.status, response.value) of
        (400, Text body) ->
          case Json.decodeString errorsDecoder body of
            Ok errors ->
              Err errors
            Err _ ->
              Err serverError
        _ ->
          Err serverError

    True ->
      case response.value of
        Text body ->
          Json.decodeString decoder body
            |> Result.formatError (\_ -> serverError)
        _ ->
          Err serverError


errorsDecoder : Json.Decoder FormErrors
errorsDecoder =
  Json.dict (Json.list Json.string)


serverError : FormErrors
serverError =
  Dict.singleton "global" ["Unexpected server response."]
