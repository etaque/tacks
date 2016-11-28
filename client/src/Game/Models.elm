module Game.Models exposing (..)

import Model.Shared exposing (..)
import Game.Core as Core
import Maybe as M
import Time exposing (..)
import Dict exposing (Dict)


markRadius : Float
markRadius =
    5


boatWidth : Float
boatWidth =
    3


windShadowLength : Float
windShadowLength =
    120


windHistorySampling : Float
windHistorySampling =
    2000


windHistoryLength : Float
windHistoryLength =
    windHistorySampling * 30


type alias GameState =
    { wind : Wind
    , windHistory : WindHistory
    , gusts : TiledGusts
    , playerState : PlayerState
    , wake : List Point
    , center : Point
    , opponents : List Opponent
    , ghosts : List Ghost
    , course : Course
    , tallies : List PlayerTally
    , timers : Timers
    , chatting : Bool
    }


type alias Timers =
    { serverTime : Time
    , startTime : Maybe Time
    , localTime : Time
    , lastServerUpdate : Time
    }



-- Wind


type alias Wind =
    { origin : Float
    , speed : Float
    , gusts : List Gust
    , gustCounter : Int
    }


type alias WindHistory =
    { samples : List WindSample
    , lastSample : Time
    , init : Time
    }


type alias WindSample =
    { origin : Float
    , speed : Float
    , time : Time
    }


type alias Gust =
    { position : Point
    , angle : Float
    , speed : Float
    , radius : Float
    , maxRadius : Float
    , spawnedAt : Float
    }


type alias TiledGusts =
    { genTime : Time
    , gusts : List TiledGust
    }


type alias TiledGust =
    { position : Point
    , radius : Float
    , tiles : Dict Coords GustTile
    }


type alias GustTile =
    { angle : Float
    , speed : Float
    }



-- Player


type alias PlayerState =
    { player : Player
    , time : Float
    , position : Point
    , isGrounded : Bool
    , isTurning : Bool
    , heading : Float
    , velocity : Float
    , vmgValue : Float
    , windAngle : Float
    , windOrigin : Float
    , windSpeed : Float
    , downwindVmg : Vmg
    , upwindVmg : Vmg
    , shadowDirection : Float
    , trail : List Point
    , controlMode : ControlMode
    , tackTarget : Maybe Float
    , crossedGates : List Time
    , nextGate : Maybe Gate
    }


type ControlMode
    = FixedAngle
    | FixedHeading


type alias Vmg =
    { angle : Float
    , speed : Float
    , value : Float
    }


type alias Opponent =
    { player : Player
    , state : OpponentState
    }


type alias OpponentState =
    { time : Float
    , position : Point
    , heading : Float
    , velocity : Float
    , windAngle : Float
    , windOrigin : Float
    , shadowDirection : Float
    , crossedGates : List Time
    }


type alias Ghost =
    { position : Point
    , heading : Float
    , id : String
    , handle : Maybe String
    , gates : List Time
    }



-- type GateLocation = Upwind | Downwind


areaBox : RaceArea -> ( Point, Point )
areaBox { rightTop, leftBottom } =
    ( rightTop, leftBottom )


areaDims : RaceArea -> ( Float, Float )
areaDims { rightTop, leftBottom } =
    let
        ( r, t ) =
            rightTop

        ( l, b ) =
            leftBottom
    in
        ( r - l, t - b )


areaTop : RaceArea -> Float
areaTop { rightTop } =
    Tuple.second rightTop


areaBottom : RaceArea -> Float
areaBottom { leftBottom } =
    Tuple.second leftBottom


areaWidth : RaceArea -> Float
areaWidth =
    areaDims >> Tuple.first


areaHeight : RaceArea -> Float
areaHeight =
    areaDims >> Tuple.second


areaCenters : RaceArea -> ( Float, Float )
areaCenters { rightTop, leftBottom } =
    let
        ( r, t ) =
            rightTop

        ( l, b ) =
            leftBottom

        cx =
            (r + l) / 2

        cy =
            (t + b) / 2
    in
        ( cx, cy )


genX : Float -> Float -> RaceArea -> Float
genX seed margin area =
    let
        effectiveWidth =
            (areaWidth area) - margin * 2

        ( cx, _ ) =
            areaCenters area
    in
        (Core.floatMod seed effectiveWidth) - effectiveWidth / 2 + cx


upwind s =
    abs s.windAngle < 90


closestVmgAngle s =
    if upwind s then
        s.upwindVmg.angle
    else
        s.downwindVmg.angle


windAngleOnVmg s =
    if s.windAngle < 0 then
        -(closestVmgAngle s)
    else
        closestVmgAngle s



--headingOnVmg s = ensure360 (s.windOrigin + closestVmgAngle s)


deltaToVmg s =
    s.windAngle - windAngleOnVmg s


asOpponentState : PlayerState -> OpponentState
asOpponentState { time, position, heading, velocity, windAngle, windOrigin, shadowDirection, crossedGates } =
    { time = time
    , position = position
    , heading = heading
    , velocity = velocity
    , windAngle = windAngle
    , windOrigin = windOrigin
    , shadowDirection = shadowDirection
    , crossedGates = crossedGates
    }


defaultVmg : Vmg
defaultVmg =
    { angle = 0, speed = 0, value = 0 }


defaultPlayerState : Player -> Float -> PlayerState
defaultPlayerState player time =
    { player = player
    , time = time
    , position = ( 0, 0 )
    , isGrounded = False
    , isTurning = False
    , heading = 0
    , velocity = 0
    , vmgValue = 0
    , windAngle = 0
    , windOrigin = 0
    , windSpeed = 0
    , downwindVmg = defaultVmg
    , upwindVmg = defaultVmg
    , shadowDirection = 0
    , trail = []
    , controlMode = FixedHeading
    , tackTarget = Nothing
    , crossedGates = []
    , nextGate = Nothing
    }


defaultGate : Gate
defaultGate =
    { label = Nothing
    , center = ( 0, 0 )
    , width = 100
    , orientation = North
    }


defaultWind : Wind
defaultWind =
    { origin = 0
    , speed = 0
    , gusts = []
    , gustCounter = 0
    }


emptyWindHistory : Time -> WindHistory
emptyWindHistory time =
    { samples = []
    , lastSample = 0
    , init = time
    }


defaultGame : Time -> Course -> Player -> GameState
defaultGame time course player =
    { wind = defaultWind
    , windHistory = emptyWindHistory time
    , gusts = TiledGusts time []
    , playerState = defaultPlayerState player time
    , center = ( 0, 0 )
    , wake = []
    , opponents = []
    , ghosts = []
    , course = course
    , tallies = []
    , timers =
        { serverTime =
            time
            -- , countdown = 0
        , startTime = Nothing
        , localTime = time
        , lastServerUpdate = time
        }
    , chatting = False
    }


getGateMarks : Gate -> ( Point, Point )
getGateMarks { center, width, orientation } =
    case orientation of
        North ->
            ( ( Tuple.first center - width / 2, Tuple.second center ), ( Tuple.first center + width / 2, Tuple.second center ) )

        South ->
            ( ( Tuple.first center + width / 2, Tuple.second center ), ( Tuple.first center - width / 2, Tuple.second center ) )

        East ->
            ( ( Tuple.first center, Tuple.second center - width / 2 ), ( Tuple.first center, Tuple.second center + width / 2 ) )

        West ->
            ( ( Tuple.first center, Tuple.second center + width / 2 ), ( Tuple.first center, Tuple.second center - width / 2 ) )


findPlayerGhost : String -> List Ghost -> Maybe Ghost
findPlayerGhost playerId ghosts =
    Core.find (\g -> g.id == playerId) ghosts


findOpponent : List PlayerState -> String -> Maybe PlayerState
findOpponent opponents id =
    Core.find (\ps -> ps.player.id == id) opponents


raceTime : GameState -> Float
raceTime { timers } =
    case timers.startTime of
        Just t ->
            timers.serverTime - t

        Nothing ->
            0


isStarted : GameState -> Bool
isStarted { timers } =
    case timers.startTime of
        Just t ->
            timers.serverTime >= t

        Nothing ->
            False
