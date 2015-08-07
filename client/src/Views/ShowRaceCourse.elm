module Views.ShowRaceCourse where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
-- import Graphics.Element exposing (..)
-- import Graphics.Input exposing (..)
-- import Text

import State exposing (..)
import Messages exposing (Translator)
import Game.Inputs exposing (navigate)

import Views.Utils exposing (..)


view : RaceCourseStatus -> Translator -> AppState -> Html
view {raceCourse,opponents} t appState =
  div [ class "show-race-course" ]
    [ titleWrapper
      [ h1 [] [ text <| raceCourseName t raceCourse ]
      , joinButton raceCourse t
      ]
    ]

joinButton : RaceCourse -> Translator -> Html
joinButton raceCourse t =
  a
    [ class "btn btn-warning btn-warning join-race-course"
    , path ("/play/" ++ raceCourse.slug)
    ] [ text "Join"]
