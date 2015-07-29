module LiveCenter.Update where


import Http
import Task exposing (Task)
import Json.Decode as Json

import Game exposing (..)
import LiveCenter.State exposing (..)
import LiveCenter.Decoders exposing (serverInputDecoder)


type Action
  = NoOp
  | ServerUpdate ServerInput
  | ShowCourse RaceCourse
  | HideCourse


actionsMailbox : Signal.Mailbox Action
actionsMailbox =
  Signal.mailbox NoOp


updateState : Action -> State -> State
updateState action state =
  case action of

    NoOp ->
      state

    ServerUpdate input ->
      { state |
        courses <- input.raceCourses,
        currentPlayer <- input.currentPlayer
      }

    ShowCourse course ->
      { state | course <- Just course }

    HideCourse ->
      { state | course <- Nothing }


fetchServerUpdate : Task Http.Error Action
fetchServerUpdate =
  Http.get (Json.map ServerUpdate serverInputDecoder) "/api/liveStatus"


runServerUpdate : Task Http.Error ()
runServerUpdate =
  fetchServerUpdate `Task.andThen` (Signal.send actionsMailbox.address)


