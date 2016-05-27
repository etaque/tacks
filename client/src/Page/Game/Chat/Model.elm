module Page.Game.Chat.Model exposing (..)

import Model.Shared exposing (..)


type alias Model =
  { messages : List Message
  , field : String
  , focus : Bool
  }


initial : Model
initial =
  { messages = []
  , field = ""
  , focus = False
  }


type Msg
  = AddMessage Message
  | Enter Bool
  | Exit Bool
  | UpdateField String
  | Submit
  | NoOp


keyCodeToMsg : Model -> Int -> Msg
keyCodeToMsg model code =
  if model.focus then
    if code == esc then
      Exit True
    else if code == enter then
      Submit
    else
      NoOp
  else
    if code == esc then
      Enter True
    else
      NoOp


esc : Int
esc =
  27


enter : Int
enter =
  13


fieldId : String
fieldId =
  "game-chat"
