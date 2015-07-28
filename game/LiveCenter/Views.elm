module LiveCenter.Views where

import Html exposing (..)
import Html.Attributes exposing (..)
-- import Html.Events exposing (..)

import LiveCenter.State exposing (..)
-- import LiveCenter.Update exposing (actionsMailbox)
import Messages exposing (Translator)


mainView : Translator -> State -> Html
mainView t state =
  div [] (List.map (raceCourseStatusView t) state.courses)

raceCourseStatusView : Translator -> RaceCourseStatus -> Html
raceCourseStatusView t {raceCourse,opponents} =
  div [ class "race-course-status" ]
    [ a [ href ("/course/" ++ raceCourse.id) ] [ text raceCourse.slug ]
    , text (toString raceCourse.countdown)
    ]
