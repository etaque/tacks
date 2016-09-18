module Page.Game.Decoders exposing (..)

import Json.Decode as Json exposing (..)
import Decoders exposing (..)
import Game.Decoders exposing (..)
import Page.Game.Model exposing (..)
import Page.Game.Chat.Model as Chat
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

        "LiveTrack" ->
            map UpdateLiveTrack ("liveTrack" := liveTrackDecoder)

        "Message" ->
            map (ChatMsg << Chat.AddMessage) ("message" := messageDecoder)

        _ ->
            fail <| tag ++ " is not a recognized tag for msgs"
