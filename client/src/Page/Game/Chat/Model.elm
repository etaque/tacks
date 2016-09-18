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


fieldId : String
fieldId =
    "chat-input-field"


messagesId : String
messagesId =
    "chat-messages-list"
