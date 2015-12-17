module ServerApi where

import Http exposing (..)
import Task exposing (Task, andThen)
import Json.Decode as Json
import Json.Encode as JsEncode
import Dict exposing (Dict)
import Result exposing (Result(Ok,Err))
import Effects exposing (Never)

import Models exposing (..)
import Decoders exposing (..)
import Encoders exposing (..)



-- GET

type alias GetJsonTask a = Task Never (Result () a)

getPlayer : String -> GetJsonTask Player
getPlayer handle =
  getJson playerDecoder ("/api/players/" ++ handle)

getLiveStatus : GetJsonTask LiveStatus
getLiveStatus =
  getJson liveStatusDecoder "/api/liveStatus"

getTrack : String -> GetJsonTask Track
getTrack id =
  getJson trackDecoder ("/api/track/" ++ id)

getLiveTrack : String -> GetJsonTask LiveTrack
getLiveTrack id =
  getJson liveTrackDecoder ("/api/liveTrack/" ++ id)

getDrafts : GetJsonTask (List Track)
getDrafts =
  getJson (Json.list trackDecoder) "/api/drafts"

loadAdminData : GetJsonTask AdminData
loadAdminData =
  getJson adminDataDecoder "/api/admin"

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
  let
    body = JsEncode.object
      [ ("email", JsEncode.string email)
      , ("password", JsEncode.string password)
      ]
   in
     postJson playerDecoder "/api/login" body

postLogout : Task Never (FormResult Player)
postLogout =
  postJson playerDecoder "/api/logout" JsEncode.null

createTrack : String -> Task Never (FormResult Track)
createTrack name =
  let
    body = JsEncode.object [ ("name", JsEncode.string name) ]
  in
    postJson trackDecoder "/api/track" body

saveTrack : String -> String -> Course -> Task Never (FormResult Track)
saveTrack id name course =
  let
    body = JsEncode.object
      [ ("course", courseEncoder course)
      , ("name", JsEncode.string name)
      ]
  in
    postJson trackDecoder ("/api/track/" ++ id) body

publishTrack : String -> Task Never (FormResult Track)
publishTrack id =
  postJson trackDecoder ("/api/track/" ++ id ++ "/publish") JsEncode.null

deleteDraft : String -> Task Never (FormResult String)
deleteDraft id =
  postJson (Json.succeed id) ("/api/track/" ++ id ++ "/delete") JsEncode.null

-- Tooling

getJson : Json.Decoder a -> String -> GetJsonTask a
getJson decoder path =
  Http.get decoder path
    |> Task.toResult
    |> Task.map (Result.formatError (\_ -> ()))


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
