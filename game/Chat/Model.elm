module Chat.Model where

import Maybe as M
import List
import Json.Decode (..)
import Json.Encode as E

import Game (Player, defaultPlayer)


type alias Model =
  { messages: List Message
  , players: List Player
  , currentPlayer: Player
  , messageField: String
  , statusField: String
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
  , messageField = ""
  , statusField = ""
  }

type Action
  = NoOp
  | Ping
  | SetPlayer Player
  | UpdateMessageField String
  | UpdateStatusField String
  | UpdatePlayers (List Player)
  | NewMessage Player String
  | SubmitMessage String
  | SubmitStatus String

actionDecoder : Decoder Action
actionDecoder =
  ("tag" := string) `andThen` specificActionDecoder

specificActionDecoder : String -> Decoder Action
specificActionDecoder tag =
  case tag of

    "NoOp" -> succeed NoOp

    "Ping" -> succeed Ping

    "SetPlayer" ->
      object1 SetPlayer ("player" := playerDecoder)

    "UpdateMessageField" ->
      object1 UpdateMessageField
        ("content" := string)

    "UpdateStatusField" ->
      object1 UpdateStatusField
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
  object6 Player
    ("id" := string)
    (maybe ("handle" := string))
    (maybe ("status" := string))
    (maybe ("avatarId" := string))
    ("guest" := bool)
    ("user" := bool)

actionEncoder : Action -> Value
actionEncoder action =
  case action of

    SubmitMessage content ->
      E.object
        [ ("tag", E.string "SubmitMessage")
        , ("content", E.string content)
        ]

    SubmitStatus content ->
      E.object
        [ ("tag", E.string "SubmitStatus")
        , ("content", E.string content)
        ]

    Ping -> E.object [ ("tag", E.string "Ping") ]

    _ -> E.object [ ("tag", E.string "NoOp") ]
