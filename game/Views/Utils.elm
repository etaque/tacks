module Views.Utils where

-- import Graphics.Element exposing (..)
-- import Graphics.Input exposing (..)
import Text exposing (Text)

import State exposing (..)
import Messages exposing (Translator)


raceCourseName : Translator -> RaceCourse -> Text
raceCourseName t {slug} =
  Text.fromString (t <| "generators." ++ slug ++ ".name")
