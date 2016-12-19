module Game.Decoders exposing (..)

import Json.Decode as Json exposing (..)
import Decoders exposing (..)
import Game.Shared exposing (..)
import Game.Inputs exposing (RaceInput)


raceInputDecoder : Decoder RaceInput
raceInputDecoder =
    map8
        RaceInput
        (field "serverTime" float)
        (field "startTime" (maybe float))
        (field "wind" windDecoder)
        (field "opponents" (list opponentDecoder))
        (field "ghosts" (list ghostDecoder))
        (field "tallies" (list playerTallyDecoder))
        (field "initial" bool)
        (field "clientTime" float)


windDecoder : Decoder Wind
windDecoder =
    map4
        Wind
        (field "origin" float)
        (field "speed" float)
        (field "gusts" (list gustDecoder))
        (field "gustCounter" int)


gustDecoder : Decoder Gust
gustDecoder =
    map6
        Gust
        (field "position" pointDecoder)
        (field "angle" float)
        (field "speed" float)
        (field "radius" float)
        (field "maxRadius" float)
        (field "spawnedAt" float)


ghostDecoder : Decoder Ghost
ghostDecoder =
    map5
        Ghost
        (field "position" pointDecoder)
        (field "heading" float)
        (field "id" string)
        (field "handle" (maybe string))
        (field "gates" (list float))


opponentDecoder : Decoder Opponent
opponentDecoder =
    map2
        Opponent
        (field "player" playerDecoder)
        (field "state" opponentStateDecoder)


opponentStateDecoder : Decoder OpponentState
opponentStateDecoder =
    map8 OpponentState
        (field "time" float)
        (field "position" pointDecoder)
        (field "heading" float)
        (field "velocity" float)
        (field "windAngle" float)
        (field "windOrigin" float)
        (field "shadowDirection" float)
        (field "crossedGates" (list float))
