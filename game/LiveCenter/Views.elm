module LiveCenter.Views where

import Html exposing (..)
import Html.Attributes exposing (..)
-- import Html.Events exposing (..)

import Chat.Views exposing (playerWithAvatar)
import LiveCenter.State exposing (..)
import Game exposing (OpponentState,Opponent)
-- import LiveCenter.Update exposing (actionsMailbox)
import Messages exposing (Translator)


mainView : Translator -> State -> Html
mainView t state =
  div [ class "row" ] (List.map (raceCourseStatusView t) state.courses)

raceCourseStatusView : Translator -> RaceCourseStatus -> Html
raceCourseStatusView t {raceCourse,opponents} =
  div [ class "col-md-4" ]
    [ div [ class "race-course-status" ]
      [ a [ href ("/course/" ++ raceCourse.id), target "course" ]
          [ text (t <| "generators." ++ raceCourse.slug ++ ".name") ]
      , opponentsList opponents
      ]
    ]

opponentsList : List Opponent -> Html
opponentsList opponents =
  ul [ class "race-course-opponents" ] (List.map opponentView opponents)

opponentView : Opponent -> Html
opponentView {player,state} =
  li [ class "opponent" ] [ playerWithAvatar player ]

