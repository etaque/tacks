module Game where

import Geo (..)
import Json
import Dict

type Gate = { y: Float, width: Float }
type Island = { location : Point, radius : Float }
type RaceArea = { rightTop: Point, leftBottom: Point }

type Course =
  { upwind: Gate
  , downwind: Gate
  , laps: Int
  , markRadius: Float
  , islands: [Island]
  , area: RaceArea
  , windShadowLength: Float
  , boatWidth: Float
  }

type PlayerState =
  { player: { handle: Maybe String }
  , position: Point
  , heading: Float
  , velocity: Float
  , windAngle: Float
  , windOrigin: Float
  , windSpeed: Float
  , downwindVmg: Float
  , upwindVmg: Float
  , trail: [Point]
  , controlMode: String
  , tackTarget: Maybe Float
  , crossedGates: [Time]
  , nextGate: Maybe String -- GateLocation data type is incompatible with port inputs
  }

type PlayerTally = { playerId: String, playerHandle: Maybe String, gates: [Time] }

type Gust = { position : Point, angle: Float, speed: Float, radius: Float }
type Wind = { origin : Float, speed : Float, gusts : [Gust] }

type GameState =
  { wind: Wind
  , playerState: PlayerState
  , wake: [Point]
  , center: Point
  , opponents: [PlayerState]
  , course: Course
  , leaderboard: [PlayerTally]
  , now: Time
  , countdown: Maybe Time
  , isMaster: Bool
  }

--type RaceState = { players : [PlayerState] }

defaultGate : Gate
defaultGate = { y = 0, width = 0 }

defaultCourse : Course
defaultCourse =
  { upwind = defaultGate
  , downwind = defaultGate
  , laps = 0
  , markRadius = 0
  , islands = []
  , area = { rightTop = (0,0), leftBottom = (0,0) }
  , windShadowLength = 0
  , boatWidth = 0
  }

defaultPlayerState : PlayerState
defaultPlayerState =
  { player = { handle = Nothing }
  , position = (0,0)
  , heading = 0
  , velocity = 0
  , windAngle = 0
  , windOrigin = 0
  , windSpeed = 0
  , trail = []
  , controlMode = "FixedHeading"
  , tackTarget = Nothing
  , crossedGates = []
  , nextGate = Nothing
  , downwindVmg = 0
  , upwindVmg = 0
  }

defaultWind : Wind
defaultWind =
  { origin = 0
  , speed = 0
  , gusts = []
  }

defaultGame : GameState
defaultGame =
  { wind = defaultWind
  , playerState = defaultPlayerState
  , center = (0,0)
  , wake = []
  , opponents = []
  , course = defaultCourse
  , leaderboard = []
  , now = 0
  , countdown = Nothing
  , isMaster = False
  }

getGateMarks : Gate -> (Point,Point)
getGateMarks gate = ((-gate.width / 2, gate.y), (gate.width / 2, gate.y))
