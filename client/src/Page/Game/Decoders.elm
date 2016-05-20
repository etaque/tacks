module Page.Game.Decoders exposing (..)

import Json.Decode as Json exposing (..)

import Decoders exposing (..)
import Page.Game.Model exposing (..)


decodeMsg : Json.Value -> Msg
decodeMsg value =
  case Json.decodeValue msgDecoder value of
    Err e -> NoOp
    Ok msg -> msg

msgDecoder : Decoder Msg
msgDecoder =
  ("tag" := string) `andThen` specificMsgDecoder

specificMsgDecoder : String -> Decoder Msg
specificMsgDecoder tag =
  case tag of

    "NoOp" -> succeed NoOp

    "LiveTrack" ->
      object1 UpdateLiveTrack ("liveTrack" := liveTrackDecoder)

    "Message" ->
      object1 NewMessage ("message" := messageDecoder)

    _ ->
        fail <| tag ++ " is not a recognized tag for msgs"
