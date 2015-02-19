module Game where

import Geo (..)
import Core

import Maybe as M
import Time (..)
import List (..)

type alias Gate = { y: Float, width: Float }
type alias Island = { location : Point, radius : Float }
type alias RaceArea = { rightTop: Point, leftBottom: Point }

type alias Vmg =
  { angle: Float
  , speed: Float
  , value: Float
  }

type alias Course =
  { upwind:           Gate
  , downwind:         Gate
  , laps:             Int
  , markRadius:       Float
  , islands:          List Island
  , area:             RaceArea
  , windShadowLength: Float
  , boatWidth:        Float
  }

type alias Player =
  { id:     String
  , handle: Maybe String
  , status: Maybe String
  , avatarId: Maybe String
  , guest: Bool
  , user: Bool
  }

type alias PlayerState =
  { player:          Player
  , position:        Point
  , heading:         Float
  , velocity:        Float
  , vmgValue:        Float
  , windAngle:       Float
  , windOrigin:      Float
  , windSpeed:       Float
  , downwindVmg:     Vmg
  , upwindVmg:       Vmg
  , shadowDirection: Float
  , trail:           List Point
  , controlMode:     String
  , tackTarget:      Maybe Float
  , crossedGates:    List Time
  , nextGate:        Maybe String
  }

upwind s = abs s.windAngle < 90
closestVmgAngle s = if upwind s then s.upwindVmg.angle else s.downwindVmg.angle
windAngleOnVmg s = if s.windAngle < 0 then -(closestVmgAngle s) else closestVmgAngle s
headingOnVmg s = ensure360 (s.windOrigin + closestVmgAngle s)
deltaToVmg s = s.windAngle - windAngleOnVmg s

type alias PlayerTally = { playerId: String, playerHandle: Maybe String, gates: List Time }

type alias GhostState =
  { position: Point
  , heading:  Float
  , id:       String
  , handle:   Maybe String
  , gates:    List Time
  }

type alias Gust = { position : Point, angle: Float, speed: Float, radius: Float }
type alias Wind = { origin : Float, speed : Float, gusts : List Gust }

type WatchMode = NotWatching | Watching String
type GameMode = Race | TimeTrial

type alias GameState =
  { wind:        Wind
  , playerId:    String
  , playerState: Maybe PlayerState
  , wake:        List Point
  , center:      Point
  , opponents:   List PlayerState
  , ghosts:      List GhostState
  , course:      Course
  , leaderboard: List PlayerTally
  , now:         Time
  , countdown:   Maybe Time
  , isMaster:    Bool
  , watchMode:   WatchMode
  , gameMode:    GameMode
  }


defaultVmg : Vmg
defaultVmg = { angle = 0, speed = 0, value = 0}

defaultPlayer : Player
defaultPlayer = { id = "", handle = Nothing, user = False, guest = False, status = Nothing, avatarId = Nothing }

defaultPlayerState : PlayerState
defaultPlayerState =
  { player          = defaultPlayer
  , position        = (0,0)
  , heading         = 0
  , velocity        = 0
  , vmgValue        = 0
  , windAngle       = 0
  , windOrigin      = 0
  , windSpeed       = 0
  , downwindVmg     = defaultVmg
  , upwindVmg       = defaultVmg
  , shadowDirection = 0
  , trail           = []
  , controlMode     = ""
  , tackTarget      = Nothing
  , crossedGates    = []
  , nextGate        = Nothing
  }


defaultGate : Gate
defaultGate = { y = 0, width = 0 }

defaultCourse : Course
defaultCourse =
  { upwind           = defaultGate
  , downwind         = defaultGate
  , laps             = 0
  , markRadius       = 0
  , islands          = []
  , area             = { rightTop = (0,0), leftBottom = (0,0) }
  , windShadowLength = 0
  , boatWidth        = 0
  }

defaultWind : Wind
defaultWind =
  { origin = 0
  , speed  = 0
  , gusts  = []
  }

defaultGame : GameState
defaultGame =
  { wind        = defaultWind
  , playerId    = ""
  , playerState = Nothing
  , center      = (0,0)
  , wake        = []
  , opponents   = []
  , ghosts      = []
  , course      = defaultCourse
  , leaderboard = []
  , now         = 0
  , countdown   = Nothing
  , isMaster    = False
  , watchMode   = NotWatching
  , gameMode    = Race
  }

getGateMarks : Gate -> (Point,Point)
getGateMarks gate = ((-gate.width / 2, gate.y), (gate.width / 2, gate.y))

findPlayerGhost : String -> List GhostState -> Maybe GhostState
findPlayerGhost playerId ghosts =
  Core.find (\g -> g.id == playerId) ghosts

areaDims : RaceArea -> (Float,Float)
areaDims {rightTop,leftBottom} =
  let
    (r,t) = rightTop
    (l,b) = leftBottom
  in
    (r - l, t - b)

areaTop : RaceArea -> Float
areaTop {rightTop} = snd rightTop

areaBottom : RaceArea -> Float
areaBottom {leftBottom} = snd leftBottom

areaWidth : RaceArea -> Float
areaWidth = areaDims >> fst

areaHeight : RaceArea -> Float
areaHeight = areaDims >> snd

areaCenters : RaceArea -> (Float,Float)
areaCenters {rightTop,leftBottom} =
  let
    (r,t) = rightTop
    (l,b) = leftBottom
    cx = (r + l) / 2
    cy = (t + b) / 2
  in
    (cx, cy)

findOpponent : List PlayerState -> String -> Maybe PlayerState
findOpponent opponents id =
  let filtered = filter (\ps -> ps.player.id == id) opponents
  in  if isEmpty filtered then Nothing else Just (head filtered)

selfWatching : GameState -> Bool
selfWatching {watchMode,playerId} =
  case watchMode of
    Watching pid -> pid == playerId
    NotWatching  -> False

isInProgress : GameState -> Bool
isInProgress {countdown,playerState} =
  case (countdown, playerState) of
    (Just c, Just ps) -> c <= 0 && case ps.nextGate of
      Just _ -> True
      Nothing -> False
    _ -> False

