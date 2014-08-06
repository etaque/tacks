module GameSkeleton where

import Keyboard
import Window

{-- Part 1: Model the user input ----------------------------------------------

What information do you need to represent all relevant user input?

Task: Redefine `UserInput` to include all of the information you need.
      Redefine `userInput` to be a signal that correctly models the user
      input as described by `UserInput`.

------------------------------------------------------------------------------}

type UserInput = { x:Int, y:Int }

userInput : Signal UserInput
userInput = Keyboard.arrows

type Input = { timeDelta:Float, userInput:UserInput }



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

type Boat = { x: Float, y: Float, direction: Int, velocity: Float, windAngle: Int }

boat : Boat
boat = { x = 0, y = -20, direction = 0, velocity = 0, windAngle = 0 }

type Wind = { origin: Int }

wind : Wind
wind = { origin = 0 }

type StartLine = { left: (Float, Float), right: (Float, Float) }

startLine : StartLine
startLine = { left = (-50, 0), right = (50, 0) }

type GameState = { wind: Wind, boat: Boat, startLine: StartLine }

defaultGame : GameState
defaultGame = { wind = wind, boat = boat, startLine = startLine }



{-- Part 3: Update the game ---------------------------------------------------

How does the game step from one state to another based on user input?

Task: redefine `stepGame` to use the UserInput and GameState
      you defined in parts 1 and 2. Maybe use some helper functions
      to break up the work, stepping smaller parts of the game.

------------------------------------------------------------------------------}

type Arrows = { x:Int, y:Int }

ensure360 : Int -> Int
ensure360 val = (val + 360) `mod` 360

angleToWind : Int -> Int -> Int
angleToWind boatDirection windOrigin = 
  let delta = windOrigin - boatDirection
      delta360 = if | delta > 180   -> delta - 360
                    | delta <= -180 -> delta + 360
                    | otherwise     -> delta
  in abs delta360

toRadians : Int -> Float
toRadians deg = radians (toFloat(90 - deg) * pi / 180)
--toRadians deg = degrees(toFloat(deg))

polarVelocity : Int -> Float
polarVelocity delta =
  let x = toFloat(delta)
      v = 1.084556812 * (10^ -6) * (x^3) - 1.058704484 * (10^ -3) * (x^2) + 0.195782694 * x - 7.136475544 * (10^ -1)
  in if v < 0 then 0 else v

  --toFloat(windDelta) / 2

keysStep : Arrows -> GameState -> GameState
keysStep arrows gameState =
    let boat = gameState.boat
        newBoat = { boat | direction <- ensure360 <| boat.direction + arrows.x }
    in { gameState | boat <- newBoat }

moveStep : Time -> GameState -> GameState
moveStep delta ({wind, boat} as gameState) =
    let {x, y, direction, velocity, windAngle} = boat
        newWindAngle = angleToWind direction wind.origin
        newVelocity = polarVelocity(newWindAngle) * 5
        angle = toRadians direction
        newBoat = { boat | x <- x + delta * newVelocity * cos angle ,
                           y <- y + delta * newVelocity * sin angle ,
                           velocity <- newVelocity,
                           windAngle <- newWindAngle }
    in { gameState | boat <- newBoat }

stepGame : Input -> GameState -> GameState
stepGame input gameState = 
  keysStep input.userInput <| moveStep input.timeDelta gameState

--stepGame : Input -> GameState -> GameState
--stepGame {timeDelta,userInput} gameState = gameState



{-- Part 4: Display the game --------------------------------------------------

How should the GameState be displayed to the user?

Task: redefine `display` to use the GameState you defined in part 2.

------------------------------------------------------------------------------}

display : (Int,Int) -> GameState -> Element
display (w,h) gameState = 
  let start = traced (dotted black) <| segment gameState.startLine.left gameState.startLine.right
      boat = gameState.boat
      boatPic = image 8 19 "/boat.png" |> toForm
                                       |> rotate (toRadians (boat.direction + 90))
                                       |> move (boat.x,boat.y)
  in layers [ collage w h [boatPic, start],
              asText gameState.boat ]


{-- That's all folks! ---------------------------------------------------------

The following code puts it all together and shows it on screen.

------------------------------------------------------------------------------}

delta = inSeconds <~ fps 30
input = sampleOn delta (lift2 Input delta userInput)

gameState = foldp stepGame defaultGame input

main = lift2 display Window.dimensions gameState