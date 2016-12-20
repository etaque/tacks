module Page.PlayTimeTrial.Decoders exposing (..)

import Json.Decode as Json exposing (..)
import Game.Decoders exposing (..)
import Page.PlayTimeTrial.Model exposing (..)
import Game.Msg exposing (GameMsg(..))


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
    (field "tag" string) |> andThen specificMsgDecoder


specificMsgDecoder : String -> Decoder Msg
specificMsgDecoder tag =
    case tag of
        "NoOp" ->
            succeed NoOp

        "RaceUpdate" ->
            map (GameMsg << RaceUpdate) (field "raceUpdate" raceInputDecoder)

        _ ->
            fail <| tag ++ " is not a recognized tag for msgs"
