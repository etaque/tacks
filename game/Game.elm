module Game where

import Geo (..)
import Json
import Dict

type Gate = { y: Float, width: Float }
type Island = { location : Point, radius : Float }
type RaceArea = { rightTop: Point, leftBottom: Point }

type Vmg =
  { angle: Float
  , speed: Float
  , value: Float
  }

type Course =
  { upwind:           Gate
  , downwind:         Gate
  , laps:             Int
  , markRadius:       Float
  , islands:          [Island]
  , area:             RaceArea
  , windShadowLength: Float
  , boatWidth:        Float
  }

type Player =
  { id:     String
  , handle: Maybe String
  , status: Maybe String
  }

type PlayerState =
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
  , trail:           [Point]
  , controlMode:     String
  , tackTarget:      Maybe Float
  , crossedGates:    [Time]
  , nextGate:        Maybe String -- GateLocation data type is incompatible with port inputs
  }

type PlayerTally = { playerId: String, playerHandle: Maybe String, gates: [Time] }

type GhostState =
  { position: Point
  , heading:  Float
  , handle:   Maybe String
  }

type Gust = { position : Point, angle: Float, speed: Float, radius: Float }
type Wind = { origin : Float, speed : Float, gusts : [Gust] }

data WatchMode = NotWatching | Watching String
data GameMode = Race | TimeTrial

type GameState =
  { wind:        Wind
  , playerId:    String
  , playerState: Maybe PlayerState
  , wake:        [Point]
  , center:      Point
  , opponents:   [PlayerState]
  , ghosts:      [GhostState]
  , course:      Course
  , leaderboard: [PlayerTally]
  , now:         Time
  , countdown:   Maybe Time
  , isMaster:    Bool
  , watchMode:   WatchMode
  , gameMode:    GameMode
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

findOpponent : [PlayerState] -> String -> Maybe PlayerState
findOpponent opponents id =
  let filtered = filter (\ps -> ps.player.id == id) opponents
  in  if isEmpty filtered then Nothing else Just (head filtered)

selfWatching : GameState -> Bool
selfWatching {watchMode,playerId} =
  case watchMode of
    Watching pid -> pid == playerId
    NotWatching  -> False


