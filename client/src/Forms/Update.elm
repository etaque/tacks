module Forms.Update where

import Http
import Task exposing (Task, andThen)
import Json.Decode as Json
import Json.Encode as JsEncode
import History

import Forms.Model exposing (..)
import Inputs exposing (..)
import State
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
    UpdateRegisterForm t ->
      { forms | register <- (t forms.register) }


submitFormTask : SubmitForm -> Task Http.Error ()
submitFormTask sf =
  let
    t = case sf of
      SubmitSetHandle f ->
        postHandle f |> Task.map PlayerUpdate
      SubmitRegister f ->
        postRegister f |> Task.map PlayerUpdate |> withNewPath "/"
      SubmitLogin f ->
        postLogin f |> Task.map PlayerUpdate |> withNewPath "/"
      SubmitLogout ->
        postLogout |> Task.map PlayerUpdate
      _ ->
        Task.succeed NoOp
  in
    t `andThen` (Signal.send actionsMailbox.address)

withNewPath : String -> Task Http.Error Action -> Task Http.Error Action
withNewPath path task =
  task `andThen` (\action -> Task.map (\_ -> action) (History.setPath path))
