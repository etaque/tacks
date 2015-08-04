module Forms.Update where

import Http
import Task exposing (Task, andThen)
import Json.Decode as Json
import Json.Encode as JsEncode

import Forms.Model exposing (..)
import Inputs exposing (..)
import Decoders exposing (playerDecoder)
import ServerApi exposing (..)

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
        postHandle f |> Task.map PlayerUpdate
      SubmitLogin f ->
        postLogin f |> Task.map PlayerUpdate
      SubmitLogout ->
        postLogout |> Task.map PlayerUpdate
      _ ->
        Task.succeed NoOp
  in
    t `andThen` (Signal.send actionsMailbox.address)

