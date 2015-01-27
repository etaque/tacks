module Chat.Model where

import Maybe as M
import List
import Json.Decode (..)

import Game (Player, defaultPlayer)


type alias Model =
  { messages: List Message
  , players: List Player
  , currentPlayer: Player
  , field: String
  }

type alias Message =
  { content: String
  , player: Player
  }

emptyModel : Model
emptyModel =
  { messages = []
  , players = []
  , currentPlayer = defaultPlayer
  , field = ""
  }

type Action
  = NoOp
  | SetPlayer Player
  | UpdateField String
  | UpdatePlayers (List Player)
  | NewMessage Player String

type alias SubmitMessage =
  { content: String }


actionDecoder : Decoder Action
actionDecoder =
  ("tag" := string) `andThen` specificActionDecoder

specificActionDecoder : String -> Decoder Action
specificActionDecoder tag =
  case tag of

    "NoOp" -> succeed NoOp

    "SetPlayer" ->
      object1 SetPlayer ("player" := playerDecoder)

    "UpdateField" ->
      object1 UpdateField
        ("content" := string)

    "UpdatePlayers" ->
      object1 UpdatePlayers
        ("players" := list playerDecoder)

    "NewMessage" ->
      object2 NewMessage
        ("player" := playerDecoder)
        ("content" := string)

    _ ->
        fail <| tag ++ " is not a recognized tag for actions"


playerDecoder : Decoder Player
playerDecoder =
  object3 Player
    ("id" := string)
    (maybe ("handle" := string))
    (maybe ("status" := string))
