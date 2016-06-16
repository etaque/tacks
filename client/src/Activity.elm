module Activity exposing (..)

import Model.Shared exposing (..)
import Encoders exposing (tag)
import Json.Encode as Js
import Json.Decode exposing (..)
import Decoders exposing (playerDecoder, liveStatusDecoder)
import Ports


type EmitMsg
  = Ping
  | Poke Player


type ReceiveMsg
  = PokedBy Player
  | RefreshLiveStatus LiveStatus


encodeEmitMsg : EmitMsg -> Js.Value
encodeEmitMsg msg =
  case msg of
    Ping ->
      tag "Ping" []

    Poke player ->
      tag "Poke" [ ( "playerId", Js.string player.id ) ]


receiveMsgDecoder : Decoder ReceiveMsg
receiveMsgDecoder =
  ("tag" := string) `andThen` receiveTagDecoder


receiveTagDecoder : String -> Decoder ReceiveMsg
receiveTagDecoder tag =
  case tag of
    "PokedBy" ->
      map PokedBy ("player" := playerDecoder)

    "RefreshLiveStatus" ->
      map RefreshLiveStatus ("liveStatus" := liveStatusDecoder)

    _ ->
      fail (tag ++ " is unknown for Activity.ReceiveMsg")


notifyPokedBy : Player -> Cmd msg
notifyPokedBy player =
  Ports.notify ("You've been poked by " ++ (Maybe.withDefault "Anonymous" player.handle))
