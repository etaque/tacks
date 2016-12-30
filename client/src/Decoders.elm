module Decoders exposing (..)

import Json.Decode as Json exposing (..)
import Dict
import Model.Shared exposing (..)


tuple2 : Decoder a -> Decoder b -> Decoder ( a, b )
tuple2 da db =
    map2 (,) (index 0 da) (index 1 db)


liveStatusDecoder : Decoder LiveStatus
liveStatusDecoder =
    map3
        LiveStatus
        (field "liveTracks" (list liveTrackDecoder))
        (field "liveTimeTrial" (maybe liveTimeTrialDecoder))
        (field "onlinePlayers" (list playerDecoder))


liveTimeTrialDecoder : Decoder LiveTimeTrial
liveTimeTrialDecoder =
    map3
        LiveTimeTrial
        (field "timeTrial" timeTrialDecoder)
        (field "track" trackDecoder)
        (field "meta" trackMetaDecoder)


timeTrialDecoder : Decoder TimeTrial
timeTrialDecoder =
    map4
        TimeTrial
        (field "id" string)
        (field "trackId" string)
        (field "period" string)
        (field "creationTime" float)


liveTrackDecoder : Decoder LiveTrack
liveTrackDecoder =
    map4
        LiveTrack
        (field "track" trackDecoder)
        (field "meta" trackMetaDecoder)
        (field "players" (list playerDecoder))
        (field "races" (list raceDecoder))


trackMetaDecoder : Decoder TrackMeta
trackMetaDecoder =
    map3
        TrackMeta
        (field "creator" playerDecoder)
        (field "rankings" (list rankingDecoder))
        (field "runsCount" int)


raceDecoder : Decoder Race
raceDecoder =
    map4
        Race
        (field "id" string)
        (field "startTime" float)
        (field "players" (list playerDecoder))
        (field "tallies" (list playerTallyDecoder))


rankingDecoder : Decoder Ranking
rankingDecoder =
    map5
        Ranking
        (field "rank" int)
        (field "runId" string)
        (field "player" playerDecoder)
        (field "gates" (list float))
        (field "finishTime" float)


playerTallyDecoder : Decoder PlayerTally
playerTallyDecoder =
    map3
        PlayerTally
        (field "player" playerDecoder)
        (field "gates" (list float))
        (field "finished" bool)


trackDecoder : Decoder Track
trackDecoder =
    map7
        Track
        (field "id" string)
        (field "name" string)
        (field "creatorId" string)
        (field "status" (string) |> andThen trackStatusDecoder)
        (field "featured" bool)
        (field "creationTime" float)
        (field "updateTime" float)


trackStatusDecoder : String -> Decoder TrackStatus
trackStatusDecoder s =
    case s of
        "draft" ->
            succeed Draft

        "open" ->
            succeed Open

        "archived" ->
            succeed Archived

        "deleted" ->
            succeed Deleted

        _ ->
            fail (s ++ " is not a TrackStatus")


playerDecoder : Decoder Player
playerDecoder =
    map7
        Player
        (field "id" string)
        (maybe (field "handle" string))
        (maybe (field "status" string))
        (maybe (field "avatarId" string))
        (field "vmgMagnet" int)
        (field "guest" bool)
        (field "user" bool)


userDecoder : Decoder User
userDecoder =
    map5
        User
        (field "id" string)
        (field "handle" string)
        (maybe (field "status" string))
        (maybe (field "avatarId" string))
        (field "vmgMagnet" int)


messageDecoder : Decoder Message
messageDecoder =
    map3
        Message
        (field "content" string)
        (field "player" playerDecoder)
        (field "time" float)


pointDecoder : Decoder Point
pointDecoder =
    tuple2 float float


courseDecoder : Decoder Course
courseDecoder =
    map7
        Course
        (field "start" gateDecoder)
        (field "gates" (list gateDecoder))
        (field "grid" gridDecoder)
        (field "area" raceAreaDecoder)
        (field "windSpeed" int)
        (field "windGenerator" windGeneratorDecoder)
        (field "gustGenerator" gustGeneratorDecoder)


gateDecoder : Decoder Gate
gateDecoder =
    map4
        Gate
        (maybe (field "label" string))
        (field "center" pointDecoder)
        (field "width" float)
        (field "orientation" (string |> andThen orientationDecoder))


orientationDecoder : String -> Decoder Orientation
orientationDecoder s =
    case s of
        "N" ->
            succeed North

        "S" ->
            succeed South

        "E" ->
            succeed East

        "W" ->
            succeed West

        _ ->
            fail (s ++ " is not an Orientation")


gridDecoder : Decoder Grid
gridDecoder =
    list (tuple2 (tuple2 int int) (string |> andThen tileKindDecoder))
        |> map Dict.fromList


tileKindDecoder : String -> Decoder TileKind
tileKindDecoder s =
    case s of
        "W" ->
            succeed Water

        "G" ->
            succeed Grass

        "R" ->
            succeed Rock

        _ ->
            fail (s ++ " is not a TileKind")


raceAreaDecoder : Decoder RaceArea
raceAreaDecoder =
    map2
        RaceArea
        (field "rightTop" pointDecoder)
        (field "leftBottom" pointDecoder)


windGeneratorDecoder : Decoder WindGenerator
windGeneratorDecoder =
    map4
        WindGenerator
        (field "wavelength1" int)
        (field "amplitude1" int)
        (field "wavelength2" int)
        (field "amplitude2" int)


gustGeneratorDecoder : Decoder GustGenerator
gustGeneratorDecoder =
    map5
        GustGenerator
        (field "interval" int)
        (field "radiusBase" int)
        (field "radiusVariation" int)
        (field "speedVariation" rangeDecoder)
        (field "originVariation" rangeDecoder)


rangeDecoder : Decoder Range
rangeDecoder =
    map2
        Range
        (field "start" int)
        (field "end" int)


runDecoder : Decoder Run
runDecoder =
    map8
        Run
        (field "id" string)
        (field "trackId" string)
        (field "raceId" string)
        (field "playerId" string)
        (maybe (field "playerHandle" string))
        (field "startTime" float)
        (field "tally" (list float))
        (field "duration" float)


raceReportDecoder : Decoder RaceReport
raceReportDecoder =
    map5
        RaceReport
        (field "id" string)
        (field "startTime" float)
        (field "trackId" string)
        (field "trackName" string)
        (field "runs" (list runDecoder))


deviceControlDecoder : Decoder DeviceControl
deviceControlDecoder =
    string
        |> andThen
            (\s ->
                case s of
                    "KeyboardControl" ->
                        succeed KeyboardControl

                    "TouchControl" ->
                        succeed TouchControl

                    _ ->
                        fail <| "Unkown DeviceControl: " ++ s
            )
