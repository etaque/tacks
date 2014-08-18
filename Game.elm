module Game where

import Geo (..)

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

data GateLocation = Downwind | Upwind
type Gate = { y: Float, width: Float, markRadius: Float, location: GateLocation }
type Course = { upwind: Gate, downwind: Gate, laps: Int, markRadius: Float }

data ControlMode = FixedDirection | FixedWindAngle

type Boat = { position: Point, direction: Float, velocity: Float, windAngle: Float, 
              windOrigin: Float, windSpeed: Float,
              center: Point, controlMode: ControlMode, tackTarget: Maybe Float,
              passedGates: [(GateLocation, Time)] }

type Gust = { position : Point, radius : Float, speedImpact : Float, originDelta : Float }
type Wind = { origin : Float, speed : Float, gustsCount : Int, gusts : [Gust] }
type Island = { location : Point, radius : Float }

type GameState = { wind: Wind, boat: Boat, otherBoat: Maybe Boat, 
                   course: Course, bounds: (Point, Point), islands : [Island],
                   startDuration : Time, countdown: Maybe Time }

startLine : Gate
startLine = { y = -100, width = 100, markRadius = 5, location = Downwind }

upwindGate : Gate
upwindGate = { y = 1000, width = 100, markRadius = 5, location = Upwind }


course : Course
course = { upwind = upwindGate, downwind = startLine, laps = 3, markRadius = 5 }

boat : Boat
boat = { position = (50,-200), direction = 0, velocity = 0, windAngle = 0, 
         windOrigin = 0, windSpeed = 0,
         center = (0,0), controlMode = FixedDirection, tackTarget = Nothing,
         passedGates = [] }

otherBoat : Boat
otherBoat = { boat | position <- (-50,-200) }


wind : Wind
wind = { origin = 0, speed = 10, gustsCount = 8, gusts = [] }


islands : [Island]
islands = [ { location = (250, 300), radius = 100 },
            { location = (50, 700), radius = 80 },
            { location = (-200, 500), radius = 60 } ]

defaultGame : GameState
defaultGame = { wind = wind, boat = boat, otherBoat = Just otherBoat, 
                course = course, bounds = ((800,1200), (-800,-400)), islands = islands,
                startDuration = (30*second), countdown = Nothing }

getGateMarks : Gate -> (Point,Point)
getGateMarks gate = ((-gate.width / 2, gate.y), (gate.width / 2, gate.y))

findNextGate : Boat -> Int -> Maybe GateLocation
findNextGate boat laps =
  let c = (length boat.passedGates)
      i = c `mod` 2
  in
    if | c == laps * 2 + 1 -> Nothing
       | i == 0            -> Just Downwind 
       | otherwise         -> Just Upwind
       