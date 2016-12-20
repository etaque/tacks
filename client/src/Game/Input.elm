module Game.Input exposing (..)

import Time exposing (Time)
import Game.Shared exposing (..)
import Model.Shared exposing (..)
import Keyboard.Extra as Keyboard
import Game.Touch as Touch exposing (Touch)


type alias GameInput =
    { keyboard : KeyboardInput
    , dims : ( Int, Int )
    }


type alias KeyboardInput =
    { arrows : UserArrows
    , lock : Bool
    , tack : Bool
    }


initialKeyboard : KeyboardInput
initialKeyboard =
    { arrows = { x = 0, y = 0 }
    , lock = False
    , tack = False
    }


type alias UserArrows =
    { x : Int, y : Int }


type alias RaceInput =
    { serverTime : Time
    , startTime : Maybe Time
    , wind : Wind
    , opponents : List Opponent
    , ghosts : List Ghost
    , tallies : List PlayerTally
    , initial : Bool
    , clientTime : Time
    }


manualTurn ki =
    ki.arrows.x /= 0


isLocking ki =
    ki.arrows.y > 0 || ki.lock


keyboardInput : Keyboard.Model -> KeyboardInput
keyboardInput kb =
    { arrows = Keyboard.arrows kb
    , lock = Keyboard.isPressed Keyboard.ArrowUp kb
    , tack = Keyboard.isPressed Keyboard.Space kb
    }


touchInput : Touch -> KeyboardInput
touchInput touch =
    { arrows = { x = touch.turn, y = 0 }
    , lock = False
    , tack = False
    }


merge : KeyboardInput -> KeyboardInput -> KeyboardInput
merge k1 k2 =
    { arrows = { x = k1.arrows.x + k2.arrows.x, y = k1.arrows.y + k2.arrows.y }
    , lock = k1.lock || k2.lock
    , tack = k1.tack || k2.tack
    }
