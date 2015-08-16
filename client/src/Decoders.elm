module Decoders where

import Json.Decode as Json exposing (..)

import Models exposing (..)


liveStatusDecoder : Decoder LiveStatus
liveStatusDecoder =
  object2 LiveStatus
    ("liveTracks" := list liveTrackDecoder)
    ("onlinePlayers" := list playerDecoder)

liveTrackDecoder : Decoder LiveTrack
liveTrackDecoder =
  object3 LiveTrack
    ("track" := trackDecoder)
    ("players" := list playerDecoder)
    ("races" := list raceDecoder)

raceDecoder : Decoder Race
raceDecoder =
  object5 Race
    ("_id" := string)
    ("trackId" := string)
    ("startTime" := float)
    ("players" := list playerDecoder)
    ("tallies" := list playerTallyDecoder)

playerTallyDecoder : Decoder PlayerTally
playerTallyDecoder =
  object3 PlayerTally
    ("player" := playerDecoder)
    ("gates" := list float)
    ("finished" := bool)

trackDecoder : Decoder Track
trackDecoder =
  object5 Track
    ("_id" := string)
    ("slug" := string)
    ("course" := courseDecoder)
    ("countdown" := int)
    ("startCycle" := int)

playerDecoder : Decoder Player
playerDecoder =
  object7 Player
    ("id" := string)
    (maybe ("handle" := string))
    (maybe ("status" := string))
    (maybe ("avatarId" := string))
    ("vmgMagnet" := int)
    ("guest" := bool)
    ("user" := bool)

messageDecoder : Decoder Message
messageDecoder =
  object3 Message
    ("content" := string)
    ("player" := playerDecoder)
    ("time" := float)


-- opponentDecoder : Decoder Opponent
-- opponentDecoder =
--   object2 Opponent
--     ("player" := playerDecoder)
--     ("state" := opponentStateDecoder)

-- opponentStateDecoder : Decoder OpponentState
-- opponentStateDecoder =
--   object8 OpponentState
--     ("time" := float)
--     ("position" := pointDecoder)
--     ("heading" := float)
--     ("velocity" := float)
--     ("windAngle" := float)
--     ("windOrigin" := float)
--     ("shadowDirection" := float)
--     ("crossedGates" := list float)

pointDecoder : Decoder Point
pointDecoder =
  tuple2 (,) float float

courseDecoder : Decoder Course
courseDecoder =
  object6 Course
    ("upwind" := gateDecoder)
    ("downwind" := gateDecoder)
    ("laps" := int)
    ("islands" := list islandDecoder)
    ("area" := raceAreaDecoder)
    ("windGenerator" := windGeneratorDecoder)

gateDecoder : Decoder Gate
gateDecoder =
  object2 Gate
    ("y" := float)
    ("width" := float)

islandDecoder : Decoder Island
islandDecoder =
  object2 Island
    ("location" := pointDecoder)
    ("radius" := float)

raceAreaDecoder : Decoder RaceArea
raceAreaDecoder =
  object2 RaceArea
    ("rightTop" := pointDecoder)
    ("leftBottom" := pointDecoder)

windGeneratorDecoder : Decoder WindGenerator
windGeneratorDecoder =
  object4 WindGenerator
    ("wavelength1" := float)
    ("amplitude1" := float)
    ("wavelength2" := float)
    ("amplitude2" := float)
