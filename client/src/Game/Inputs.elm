module Game.Inputs exposing (..)

import Time exposing (Time)
import Game.Models exposing (..)
import Model.Shared exposing (..)
import Keyboard.Extra as Keyboard


type alias GameInput =
  { raceInput : RaceInput
  , keyboard : KeyboardInput
  , dims : ( Int, Int )
  , time : Time
  }


type alias Clock =
  { delta : Float
  , time : Float
  }


type alias KeyboardInput =
  { arrows : UserArrows
  , lock : Bool
  , tack : Bool
  , subtleTurn : Bool
  }


initialKeyboard : KeyboardInput
initialKeyboard =
  { arrows = { x = 0, y = 0 }
  , lock = False
  , tack = False
  , subtleTurn = False
  }


type alias UserArrows =
  { x : Int, y : Int }


type alias RaceInput =
  { serverNow : Time
  , startTime : Maybe Time
  , wind : Wind
  , opponents : List Opponent
  , ghosts : List Ghost
  , tallies : List PlayerTally
  , initial : Bool
  , clientTime : Time
  }


initialRaceInput : RaceInput
initialRaceInput =
  { serverNow = 0
  , startTime = Nothing
  , wind = defaultWind
  , opponents = []
  , ghosts = []
  , tallies = []
  , initial = True
  , clientTime = 0
  }


manualTurn ki =
  ki.arrows.x /= 0


isTurning ki =
  manualTurn ki && not ki.subtleTurn


isSubtleTurning ki =
  manualTurn ki && ki.subtleTurn


isLocking ki =
  ki.arrows.y > 0 || ki.lock


keyboardInput : Keyboard.Model -> KeyboardInput
keyboardInput kb =
  { arrows = Keyboard.arrows kb
  , lock = Keyboard.isPressed Keyboard.Enter kb
  , tack = Keyboard.isPressed Keyboard.Space kb
  , subtleTurn = Keyboard.isPressed Keyboard.Shift kb
  }

