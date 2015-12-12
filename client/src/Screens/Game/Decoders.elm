module Screens.Game.Decoders where

import Json.Decode as Json exposing (..)

import Decoders exposing (..)
import Screens.Game.Types exposing (..)


decodeAction : Json.Value -> Action
decodeAction value =
  case Json.decodeValue actionDecoder value of
    Err e -> NoOp
    Ok action -> action

actionDecoder : Decoder Action
actionDecoder =
  ("tag" := string) `andThen` specificActionDecoder

specificActionDecoder : String -> Decoder Action
specificActionDecoder tag =
  case tag of

    "NoOp" -> succeed NoOp

    "LiveTrack" ->
      object1 UpdateLiveTrack ("liveTrack" := liveTrackDecoder)

    "Message" ->
      object1 NewMessage ("message" := messageDecoder)

    _ ->
        fail <| tag ++ " is not a recognized tag for actions"
