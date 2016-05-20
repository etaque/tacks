module Game.Inputs exposing (..)

import Time exposing (Time)
import Set exposing (Set)
import Keyboard
import Char
import Game.Models exposing (..)
import Model.Shared exposing (..)


buildGameInput : ( KeyboardInput, ( Int, Int ), Maybe RaceInput ) -> Clock -> Maybe GameInput
buildGameInput ( keyboardInput, dims, maybeRaceInput ) clock =
  Maybe.map (GameInput keyboardInput dims clock) maybeRaceInput



-- Game


type alias GameInput =
  { keyboardInput : KeyboardInput
  , windowInput : ( Int, Int )
  , clock : Clock
  , raceInput : RaceInput
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


emptyKeyboardInput : KeyboardInput
emptyKeyboardInput =
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


toKeyboardInput : UserArrows -> Set Int -> KeyboardInput
toKeyboardInput arrows keys =
  { arrows = arrows
  , lock = Set.member 13 keys
  , tack = Set.member 32 keys
  , subtleTurn = Set.member 16 keys
  }


-- TODO
-- keyboardInput : Signal KeyboardInput
-- keyboardInput =
--   Signal.map2
--     toKeyboardInput
--     Keyboard.arrows
--     Keyboard.keysDown
