module Forms.Model where

import Http
import Task exposing (Task)
import Json.Decode as Json
import Json.Encode as JsEncode


type alias Forms =
  { setHandle : SetHandleForm
  , login : LoginForm
  }

type alias SetHandleForm =
  { handle : String }

type alias LoginForm =
  { email : String
  , password : String
  }

type UpdateForm
  = UpdateSetHandleForm (SetHandleForm -> SetHandleForm)
  | UpdateLoginForm (LoginForm -> LoginForm)

type SubmitForm
  = NoSubmit
  | SubmitSetHandle SetHandleForm
  | SubmitLogin LoginForm
