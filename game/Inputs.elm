module Inputs where

import Signal exposing (..)
import Time exposing (..)
import List as L
import Set as S exposing (..)
import Keyboard
import Char
import Graphics.Input
import Json.Decode as Json exposing (..)
import Task exposing (Task)
import Http

import Game exposing (..)
import State exposing (..)
import Geo exposing (Point)


type alias AppInput =
  { action : Action
  , gameInput : Maybe GameInput
  }


-- Actions

type Action
  = NoOp
  | LiveCenterUpdate LiveCenterInput
  | Navigate State.Screen

actionsMailbox : Signal.Mailbox Action
actionsMailbox =
  Signal.mailbox NoOp


-- LiveCenter

fetchServerUpdate : Task Http.Error Action
fetchServerUpdate =
  Http.get (Json.map LiveCenterUpdate liveCenterInputDecoder) "/api/liveStatus"

runServerUpdate : Task Http.Error ()
runServerUpdate =
  fetchServerUpdate `Task.andThen` (Signal.send actionsMailbox.address)

type alias LiveCenterInput =
  { raceCourses: List State.RaceCourseStatus
  , currentPlayer: Game.Player
  }


-- Game

type alias GameInput =
  { clock : Clock
  , keyboardInput : KeyboardInput
  , windowInput : (Int,Int)
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
  , startCountdown : Bool
  , escapeRun : Bool
  }

type alias UserArrows = { x : Int, y : Int }

type alias RaceInput =
  { serverNow:   Time
  , startTime:   Maybe Time
  , wind:        Game.Wind
  , opponents:   List Game.Opponent
  , ghosts:      List Game.GhostState
  , leaderboard: List Game.PlayerTally
  , isMaster:    Bool
  , initial:     Bool
  , clientTime:  Time
  }

extractGameInput : Clock -> KeyboardInput -> (Int,Int) -> Maybe RaceInput -> Maybe GameInput
extractGameInput clock keyboardInput dims maybeRaceInput =
  Maybe.map (GameInput clock keyboardInput dims) maybeRaceInput


manualTurn ki = ki.arrows.x /= 0
isTurning ki = manualTurn ki && not ki.subtleTurn
isSubtleTurning ki = manualTurn ki && ki.subtleTurn
isLocking ki = ki.arrows.y > 0 || ki.lock

toKeyboardInput : UserArrows -> Set Keyboard.KeyCode -> KeyboardInput
toKeyboardInput arrows keys =
  { arrows = arrows
  , lock = S.member 13 keys
  , tack = S.member 32 keys
  , subtleTurn = S.member 16 keys
  , startCountdown = S.member (Char.toCode 'C') keys
  , escapeRun = S.member 27 keys
  }

keyboardInput : Signal KeyboardInput
keyboardInput = Signal.map2 toKeyboardInput
  Keyboard.arrows
  Keyboard.keysDown


liveCenterInputDecoder : Json.Decoder LiveCenterInput
liveCenterInputDecoder =
  object2 LiveCenterInput
    ("raceCourses" := (Json.list <| raceCourseStatusDecoder))
    ("currentPlayer" := playerDecoder)

raceCourseStatusDecoder : Json.Decoder RaceCourseStatus
raceCourseStatusDecoder =
  object2 RaceCourseStatus
    ("raceCourse" := raceCourseDecoder)
    ("opponents" := (Json.list <| opponentDecoder))

raceCourseDecoder : Json.Decoder RaceCourse
raceCourseDecoder =
  object4 RaceCourse
    ("_id" := string)
    ("slug" := string)
    ("countdown" := int)
    ("startCycle" := int)

opponentDecoder : Json.Decoder Opponent
opponentDecoder =
  object2 Opponent
    ("player" := playerDecoder)
    ("state" := opponentStateDecoder)

playerDecoder : Decoder Player
playerDecoder =
  object7 Player
    ("id" := string)
    (maybe ("handle" := string))
    (maybe ("status" := string))
    (maybe ("avatarId" := string))
    ("vmgMagnet" := int)
    ("guest" := bool)
    ("user" := bool)
opponentStateDecoder : Json.Decoder OpponentState
opponentStateDecoder =
  object8 OpponentState
    ("time" := float)
    ("position" := pointDecoder)
    ("heading" := float)
    ("velocity" := float)
    ("windAngle" := float)
    ("windOrigin" := float)
    ("shadowDirection" := float)
    ("crossedGates" := list float)

pointDecoder : Json.Decoder Point
pointDecoder =
  tuple2 (,) float float
