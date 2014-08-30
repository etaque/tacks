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

data GateLocation = StartLine | Downwind | Upwind

type Gate = { y: Float, width: Float }
type Island = { location : Point, radius : Float }
type Course = { upwind: Gate, downwind: Gate, laps: Int, markRadius: Float, islands: [Island], bounds: (Point, Point) }

data ControlMode = FixedDirection | FixedWindAngle

type Boat a = { a | position : Point, direction: Float, velocity: Float, passedGates: [Time] }

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
 , wake: [Point]
 , center: Point
 , controlMode: ControlMode
 , tackTarget: Maybe Float
 , spellCast: Bool
 }

type Gust = { position : Point, angle: Float, speed: Float, radius: Float }
type Wind = { origin : Float, speed : Float, gusts : [Gust] }

type GameState =
  { wind: Wind
  , player: Player
  , opponents: [Opponent]
  , buoys: [Buoy]
  , course: Course
  , leaderboard: [String]
  , countdown: Time
  , playerSpell: Maybe Spell
  , triggeredSpells: [Spell]
  }

type RaceState = { players : [Player] }

defaultGate : Gate
defaultGate = { y = 0, width = 0 }

defaultCourse : Course
defaultCourse = { upwind = defaultGate, downwind = defaultGate, laps = 0, markRadius = 0,
           islands = [], bounds = ((0,0), (0,0)) }

defaultPlayer : Player
defaultPlayer =
  { position = (0,-200)
  , direction = 0
  , velocity = 0
  , windAngle = 0
  , windOrigin = 0
  , windSpeed = 0
  , wake = []
  , center = (0,0)
  , controlMode = FixedDirection
  , tackTarget = Nothing
  , passedGates = []
  , spellCast = False
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
  , opponents = []
  , buoys = []
  , course = defaultCourse
  , leaderboard = []
  , countdown = 0
  , playerSpell = Nothing
  , triggeredSpells = []
  }

getGateMarks : Gate -> (Point,Point)
getGateMarks gate = ((-gate.width / 2, gate.y), (gate.width / 2, gate.y))

findNextGate : Player -> Int -> Maybe GateLocation
findNextGate player laps =
  let c = (length player.passedGates)
      i = c `mod` 2
  in
    if | c == laps * 2 + 1 -> Nothing
       | c == 0            -> Just StartLine
       | i == 0            -> Just Downwind
       | otherwise         -> Just Upwind

