module LiveCenter.Decoders where


import Json.Decode as Json exposing (..)

import Game exposing (..)
import Geo exposing (Point)
import Chat.Model exposing (playerDecoder)

import LiveCenter.State exposing (..)


serverInputDecoder : Json.Decoder ServerInput
serverInputDecoder =
  object2 ServerInput
    ("raceCourses" := (Json.list <| raceCourseStatusDecoder))
    ("currentPlayer" := playerDecoder)

raceCourseStatusDecoder : Json.Decoder RaceCourseStatus
raceCourseStatusDecoder =
  object2 RaceCourseStatus
    ("raceCourse" := raceCourseDecoder)
    ("opponents" := (Json.list <| opponentDecoder))

raceCourseDecoder : Json.Decoder RaceCourse
raceCourseDecoder =
  object4 RaceCourse
    ("_id" := string)
    ("slug" := string)
    ("countdown" := int)
    ("startCycle" := int)

opponentDecoder : Json.Decoder Opponent
opponentDecoder =
  object2 Opponent
    ("player" := playerDecoder)
    ("state" := opponentStateDecoder)

opponentStateDecoder : Json.Decoder OpponentState
opponentStateDecoder =
  object8 OpponentState
    ("time" := float)
    ("position" := pointDecoder)
    ("heading" := float)
    ("velocity" := float)
    ("windAngle" := float)
    ("windOrigin" := float)
    ("shadowDirection" := float)
    ("crossedGates" := list float)

pointDecoder : Json.Decoder Point
pointDecoder =
  tuple2 (,) float float
