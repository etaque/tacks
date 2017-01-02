module Game.Msg exposing (..)

import Model.Shared exposing (..)
import Game.Shared exposing (RaceInput)
import Time exposing (Time)
import Window


type GameMsg
    = Left Bool
    | Right Bool
    | WindowSize Window.Size
    | RaceUpdate RaceInput
    | Frame Time
    | Tack
    | AutoVmg
    | LockWindAngle
    | StartRace
    | ExitRace
    | AddGhost String Player
    | RemoveGhost String
    | ChatMsg ChatMsg
    | GameNoOp


type ChatMsg
    = AddMessage Message
    | EnterChat
    | ExitChat
    | UpdateField String
    | ShowMessages Bool
    | SubmitMessage
