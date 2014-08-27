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

type Opponent = Boat { }

type Player = Boat { windAngle: Float, windOrigin: Float, windSpeed: Float,
                         center: Point, controlMode: ControlMode, tackTarget: Maybe Float }

type Gust = { position : Point, radius : Float, speedImpact : Float, originDelta : Float }
type Wind = { origin : Float, speed : Float, gustsCount : Int, gusts : [Gust] }

type GameState = { wind: Wind, player: Player, opponents: [Opponent],
                   course: Course, leaderboard: [String], 
                   startDuration : Time, countdown: Time }

type RaceState = { players : [Player] }

startLine : Gate
startLine = { y = -100, width = 100 }

upwindGate : Gate
upwindGate = { y = 1000, width = 100 }

islands : [Island]
islands = [ { location = (250, 300), radius = 100 },
            { location = (50, 700), radius = 80 },
            { location = (-200, 500), radius = 60 } ]

course : Course
course = { upwind = upwindGate, downwind = startLine, laps = 3, markRadius = 5,
           islands = islands, bounds = ((800,1200), (-800,-400)) }

player : Player
player = { position = (0,-200), direction = 0, velocity = 0, windAngle = 0, 
         windOrigin = 0, windSpeed = 0,
         center = (0,0), controlMode = FixedDirection, tackTarget = Nothing,
         passedGates = [] }

wind : Wind
wind = { origin = 0, speed = 10, gustsCount = 0, gusts = [] }


defaultGame : GameState
defaultGame = { wind = wind, player = player, opponents = [],
                course = course, leaderboard = [],
                startDuration = (30*second), countdown = 0 }

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

