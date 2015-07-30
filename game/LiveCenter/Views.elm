module LiveCenter.Views where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Chat.Views exposing (playerWithAvatar)
import State exposing (..)
import Game exposing (OpponentState,Opponent)
import Messages exposing (Translator)
import Inputs exposing (actionsMailbox)

indexView : Translator -> LiveCenterState -> Html
indexView t state =
  div [ class "row" ] (List.map (raceCourseStatusView t) state.courses)

raceCourseStatusView : Translator -> RaceCourseStatus -> Html
raceCourseStatusView t {raceCourse,opponents} =
  div [ class "col-md-4" ]
    [ div [ class "race-course-status" ]
      [ a
        [ onClick actionsMailbox.address (Inputs.Navigate (State.Play raceCourse))
        ]
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

