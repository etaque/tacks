module Game.Msg exposing (..)

import Model.Shared exposing (..)
import Time exposing (Time)
import Window
import Game.Input as Input
import Game.Touch as Touch exposing (Touch)
import Keyboard.Extra as Keyboard


type GameMsg
    = KeyboardMsg Keyboard.Msg
    | TouchMsg Touch.Msg
    | WindowSize Window.Size
    | RaceUpdate Input.RaceInput
    | Frame Time
    | StartRace
    | ExitRace
    | AddGhost String Player
    | RemoveGhost String
    | ChatMsg ChatMsg


type ChatMsg
    = AddMessage Message
    | EnterChat Bool
    | ExitChat Bool
    | UpdateField String
    | SubmitMessage
    | NoOp
