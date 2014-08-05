module GameSkeleton where

import Keyboard
import Window

{-- Part 1: Model the user input ----------------------------------------------

What information do you need to represent all relevant user input?

Task: Redefine `UserInput` to include all of the information you need.
      Redefine `userInput` to be a signal that correctly models the user
      input as described by `UserInput`.

------------------------------------------------------------------------------}

type UserInput = { x:Float, y:Float }

floatify {x,y} = { x = toFloat x, y = toFloat y }

userInput : Signal UserInput
userInput = floatify <~ Keyboard.arrows

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

type Boat = { x: Float, y: Float, angle: Float, velocity: Float }

boat : Boat
boat = { x = 0, y = 0, angle = pi/2, velocity = 20 }

type Wind = { angle: Float }

wind : Wind
wind = { angle = 0 }

type GameState = { wind: Wind, boat: Boat }

defaultGame : GameState
defaultGame = { wind = wind, boat = boat }



{-- Part 3: Update the game ---------------------------------------------------

How does the game step from one state to another based on user input?

Task: redefine `stepGame` to use the UserInput and GameState
      you defined in parts 1 and 2. Maybe use some helper functions
      to break up the work, stepping smaller parts of the game.

------------------------------------------------------------------------------}

type Arrows = { x:Float, y:Float }

keysStep : Arrows -> GameState -> GameState
keysStep arrows gameState =
    let boat = gameState.boat
        newBoat = { boat | angle <- boat.angle - arrows.x / 20 }
    in { gameState | boat <- newBoat }

moveStep : Time -> GameState -> GameState
moveStep delta ({wind, boat} as gameState) =
    let {x, y, angle, velocity} = boat
        newVelocity = 20 * abs(angle - wind.angle)
        newBoat = { boat | x <- x + delta * newVelocity * cos angle ,
                           y <- y + delta * newVelocity * sin angle }
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
  let boat = gameState.boat
      boatPic = image 8 19 "/boat.png" |> toForm
                                       |> rotate (boat.angle - pi/2)
                                       |> move (boat.x,boat.y)
  in layers [ collage w h [boatPic] ]


{-- That's all folks! ---------------------------------------------------------

The following code puts it all together and shows it on screen.

------------------------------------------------------------------------------}

delta = inSeconds <~ fps 30
input = sampleOn delta (lift2 Input delta userInput)

gameState = foldp stepGame defaultGame input

main = lift2 display Window.dimensions gameState