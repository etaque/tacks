module Views.Home where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import State exposing (..)
import Game exposing (..)
import Messages exposing (Translator)
import Inputs exposing (navigate)

import Views.Utils exposing (..)


view : Translator -> LiveCenterState -> Html
view t state =
  div [ class "content"]
    [ welcome t state.player
    , raceCourses t state
    ]

welcome : Translator -> Player -> Html
welcome t player =
  titleWrapper
    [ h1 [] [ text ("Welcome, " ++ (Maybe.withDefault "Anonymous" player.handle)) ]
    ]

raceCourses : Translator -> LiveCenterState -> Html
raceCourses t state =
  lightWrapper
    [ div [ class "row" ] (List.map (raceCourseStatusBlock t) state.courses)
    ]

raceCourseStatusBlock : Translator -> RaceCourseStatus -> Html
raceCourseStatusBlock t ({raceCourse,opponents} as rcs) =
  div [ class "col-md-4" ]
    [ div [ class "race-course-status" ]
      [ a
        [ clickTo (Show rcs) ]
        [ text (raceCourseName t raceCourse) ]
      , opponentsList opponents
      ]
    ]

opponentsList : List Opponent -> Html
opponentsList opponents =
  ul [ class "race-course-opponents" ] (List.map opponentItem opponents)

opponentItem : Opponent -> Html
opponentItem {player,state} =
  li [ class "opponent" ] [ playerWithAvatar player ]

-- view : Translator -> Int -> AppState -> Html
-- view t width {liveCenterState} =
--   flow right (List.map (raceCourseBlock t) liveCenterState.courses)

-- raceCourseBlock : Translator -> RaceCourseStatus -> Element
-- raceCourseBlock t ({raceCourse,opponents} as status) =
--   centered (raceCourseName t raceCourse)
--     |> clickable (navigate (Show status))
--     |> container 200 150 middle

