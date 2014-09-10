module Game where

import Geo (..)
import Json
import Dict

{-- Part 2: Model the game ----------------------------------------------------

What information do you need to represent the entire game?

Tasks: Redefine `GameState` to represent your particular game.
       Redefine `defaultGame` to represent your initial game state.

For example, if you want to represent many objects that just have a position,
your GameState might just be a list of coordinates and your default game might
be an empty list (no objects at the start):

    type GameState = { objects : [(Float,Float)] }
    defaultGame = { objects = [] }

------------------------------------------------------------------------------}

--data GateLocation = StartLine | Downwind | Upwind

type Gate = { y: Float, width: Float }
type Island = { location : Point, radius : Float }
type Course =
  { upwind: Gate
  , downwind: Gate
  , laps: Int
  , markRadius: Float
  , islands: [Island]
  , bounds: (Point, Point)
  , boatWidth: Float
  }

--data ControlMode = FixedHeading | FixedWindAngle

type Boat a = { a | position : Point, heading: Float, velocity: Float }

type Spell = { kind : String }

containsSpell : String -> [Spell] -> Bool
containsSpell spellName spells =
  let filtredSpells = filter (\spell -> spell.kind == spellName) spells
  in  length filtredSpells > 0

type Buoy = { position : Point, radius : Float, spell : Spell }

type Opponent = Boat { name : String }

type Player = Boat
  { windAngle: Float
  , windOrigin: Float
  , windSpeed: Float
  , downwindVmg: Float
  , upwindVmg: Float
  , trail: [Point]
  , controlMode: String
  , tackTarget: Maybe Float
  , crossedGates: [Time]
  , nextGate: Maybe String -- GateLocation data type is incompatible with port inputs
  , ownSpell: Maybe Spell
  }

type Gust = { position : Point, angle: Float, speed: Float, radius: Float }
type Wind = { origin : Float, speed : Float, gusts : [Gust] }

type GameState =
  { wind: Wind
  , player: Player
  , wake: [Point]
  , center: Point
  , opponents: [Opponent]
  , buoys: [Buoy]
  , course: Course
  , leaderboard: [String]
  , now: Time
  , countdown: Maybe Time
  , triggeredSpells: [Spell]
  , isMaster: Bool
  }

type RaceState = { players : [Player] }

defaultGate : Gate
defaultGate = { y = 0, width = 0 }

defaultCourse : Course
defaultCourse =
  { upwind = defaultGate
  , downwind = defaultGate
  , laps = 0
  , markRadius = 0
  , islands = []
  , bounds = ((0,0), (0,0))
  , boatWidth = 0
  }

defaultPlayer : Player
defaultPlayer =
  { position = (0,0)
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
  , ownSpell = Nothing
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
  , player = defaultPlayer
  , center = (0,0)
  , wake = []
  , opponents = []
  , buoys = []
  , course = defaultCourse
  , leaderboard = []
  , now = 0
  , countdown = Nothing
  , triggeredSpells = []
  , isMaster = False
  }

getGateMarks : Gate -> (Point,Point)
getGateMarks gate = ((-gate.width / 2, gate.y), (gate.width / 2, gate.y))

--gateLocation : Maybe String -> Maybe GateLocation
--gateLocation s =
--  case s of
--    Just "StartLine"    -> Just StartLine
--    Just "DownwindGate" -> Just Downwind
--    Just "UpwindGate"   -> Just Upwind
--    _                   -> Nothing
