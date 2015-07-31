module Views.ShowRaceCourse where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
-- import Graphics.Element exposing (..)
-- import Graphics.Input exposing (..)
-- import Text

import State exposing (..)
import Messages exposing (Translator)
import Inputs exposing (navigate)

import Views.Utils exposing (..)


view : Translator -> LiveCenterState -> RaceCourseStatus -> Html
view t liveCenterState {raceCourse,opponents} =
  div [ class "show-race-course" ]
    [ h1 [] [ text <| raceCourseName t raceCourse ]
    , joinButton raceCourse t
    ]

joinButton : RaceCourse -> Translator -> Html
joinButton raceCourse t =
  a [ class "join-race-course", clickTo (Play raceCourse) ] [ text "Join"]
