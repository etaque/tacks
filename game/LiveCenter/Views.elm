module LiveCenter.Views where

import Html exposing (..)
import Html.Attributes exposing (..)
-- import Html.Events exposing (..)

import LiveCenter.State exposing (..)
import LiveCenter.Update exposing (..)
import Messages exposing (Translator)


localActions : Signal.Mailbox Action
localActions = Signal.mailbox NoOp

mainView : Translator -> State -> Html
mainView t state =
  div [] []

raceCourseStatusView : Translator -> RaceCourseStatus -> Html
raceCourseStatusView t {raceCourse,opponents} =
  div [ class "race-course-status" ] [ text raceCourse.slug ]
