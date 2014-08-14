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
type Gate = { y: Float, width: Float, location: GateLocation }

startLine : Gate
startLine = { y = -100, width = 100, location = Downwind }

upwindGate : Gate
upwindGate = { y = 1000, width = 100, location = Upwind }

type Course = { upwind: Gate, downwind: Gate, laps: Int, markRadius: Float }

course : Course
course = { upwind = upwindGate, downwind = startLine, laps = 3, markRadius = 5 }

data ControlMode = FixedDirection | FixedWindAngle

type Boat = { position: Point, direction: Int, velocity: Float, windAngle: Int, 
              controlMode: ControlMode, tackTarget: Maybe Int,
              passedGates: [(GateLocation, Time)] }

boat : Boat
boat = { position = (50,-200), direction = 0, velocity = 0, windAngle = 0, 
         controlMode = FixedDirection, tackTarget = Nothing,
         passedGates = [] }

type Wind = { origin: Int }

wind : Wind
wind = { origin = 0 }

type GameState = { wind: Wind, boat: Boat, course: Course, 
                   bounds: (Point, Point), center: Point }

defaultGame : GameState
defaultGame = { wind = wind, boat = boat, course = course,
                bounds = ((700,1200), (-700,-300)), center = (0,0) }

nextGate : Boat -> Int -> Maybe GateLocation
nextGate boat laps =
  let c = (length boat.passedGates)
      i = c `mod` 2
  in
    if | c == laps * 2 + 1 -> Nothing
       | i == 0            -> Just Downwind 
       | otherwise         -> Just Upwind
       