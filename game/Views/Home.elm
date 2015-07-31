module Views.Home where

import Graphics.Element exposing (..)
import Graphics.Input exposing (..)
import Text

import State exposing (..)
import Messages exposing (Translator)
import Inputs exposing (navigate)

import Views.Utils exposing (..)


view : Translator -> Int -> AppState -> Element
view t width {liveCenterState} =
  flow right (List.map (raceCourseBlock t) liveCenterState.courses)

raceCourseBlock : Translator -> RaceCourseStatus -> Element
raceCourseBlock t ({raceCourse,opponents} as status) =
  centered (raceCourseName t raceCourse)
    |> clickable (navigate (Show status))

