module Forms.Update where

import Http
import Task exposing (Task, andThen)
import Json.Decode as Json
import Json.Encode as JsEncode

import Forms.Model exposing (..)
import Inputs exposing (..)


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
      _ ->
        Task.succeed NoOp
  in
    t `andThen` (Signal.send actionsMailbox.address)


postHandle : SetHandleForm -> Task Http.Error Action
postHandle f =
  postJson (Json.succeed NoOp) "/api/setHandle" <|
    JsEncode.object
      [ ("handle", JsEncode.string f.handle) ]


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
