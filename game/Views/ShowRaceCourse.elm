module Views.ShowRaceCourse where

import Graphics.Element exposing (..)
import Graphics.Input exposing (..)
import Text

import State exposing (..)
import Messages exposing (Translator)
import Inputs exposing (navigate)

import Views.Utils exposing (..)


view : Translator -> Int -> AppState -> RaceCourseStatus -> Element
view t width appState {raceCourse,opponents} =
  flow down
    [ centered (raceCourseName t raceCourse)
    , joinButton raceCourse t
    ]

joinButton : RaceCourse -> Translator -> Element
joinButton raceCourse t =
  centered (Text.fromString <| t "join")
    |> clickable (navigate (Play raceCourse))
