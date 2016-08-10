module Page.PlayTimeTrial.Decoders exposing (..)

import Json.Decode as Json exposing (..)
import Decoders exposing (..)
import Game.Decoders exposing (..)
import Page.PlayTimeTrial.Model exposing (..)
import Game.Models exposing (..)
import Game.Inputs exposing (RaceInput)


decodeStringMsg : String -> Msg
decodeStringMsg raw =
  Json.decodeString Json.value raw
    |> Result.map decodeMsg
    |> Result.withDefault NoOp


decodeMsg : Json.Value -> Msg
decodeMsg value =
  case Json.decodeValue msgDecoder value of
    Err e ->
      NoOp

    Ok msg ->
      msg


msgDecoder : Decoder Msg
msgDecoder =
  ("tag" := string) `andThen` specificMsgDecoder


specificMsgDecoder : String -> Decoder Msg
specificMsgDecoder tag =
  case tag of
    "NoOp" ->
      succeed NoOp

    "RaceUpdate" ->
      map RaceUpdate ("raceUpdate" := raceInputDecoder)

    _ ->
      fail <| tag ++ " is not a recognized tag for msgs"
