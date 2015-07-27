module LiveCenter.Update where

import Game exposing (Player)

import LiveCenter.State exposing (..)


type alias ServerInput =
  { courses: List RaceCourseStatus
  , currentPlayer: Player
  }


type Action
  = NoOp
  | ServerUpdate ServerInput
  | ShowCourse RaceCourse
  | HideCourse


updateState : Action -> State -> State
updateState action state =
  case action of

    NoOp ->
      state

    ServerUpdate input ->
      { state |
        courses <- input.courses,
        currentPlayer <- input.currentPlayer
      }

    ShowCourse course ->
      { state | course <- Just course }

    HideCourse ->
      { state | course <- Nothing }
