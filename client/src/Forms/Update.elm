module Forms.Update where

import Http
import Task exposing (Task, andThen)
import Json.Decode as Json
import Json.Encode as JsEncode

import Forms.Model exposing (..)
import Inputs exposing (..)
import Decoders exposing (playerDecoder)


submitMailbox : Signal.Mailbox SubmitForm
submitMailbox =
  Signal.mailbox NoSubmit


updateForms : UpdateForm -> Forms -> Forms
updateForms u forms =
  case u of
    UpdateSetHandleForm t ->
      { forms | setHandle <- (t forms.setHandle) }
    UpdateLoginForm t ->
      { forms | login <- (t forms.login) }


submitFormTask : SubmitForm -> Task Http.Error ()
submitFormTask sf =
  let
    t = case sf of
      SubmitSetHandle f ->
        postHandle f
      SubmitLogin f ->
        postLogin f
      SubmitLogout ->
        postLogout
      _ ->
        Task.succeed NoOp
  in
    t `andThen` (Signal.send actionsMailbox.address)


postHandle : SetHandleForm -> Task Http.Error Action
postHandle f =
  JsEncode.object
    [ ("handle", JsEncode.string f.handle)
    ]
    |> postJson (Json.map PlayerUpdate playerDecoder) "/api/setHandle"

postLogin : LoginForm -> Task Http.Error Action
postLogin f =
  JsEncode.object
    [ ("email", JsEncode.string f.email)
    , ("password", JsEncode.string f.password)
    ]
    |> postJson (Json.map PlayerUpdate playerDecoder) "/api/login"

postLogout : Task Http.Error Action
postLogout =
  postJson (Json.map PlayerUpdate playerDecoder) "/api/logout" JsEncode.null


-- Tooling

jsonToBody : JsEncode.Value -> Http.Body
jsonToBody jsValue =
  Http.string (JsEncode.encode 0 jsValue)

postJson : Json.Decoder Action -> String -> JsEncode.Value -> Task Http.Error Action
postJson decoder url jsonBody =
  Http.send Http.defaultSettings
    { verb = "POST"
    , headers = [ ("Content-Type", "application/json") ]
    , url = url
    , body = jsonToBody jsonBody
    }
    |> Http.fromJson decoder
