module Views.Home where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import State exposing (..)
import Game exposing (..)
import Messages exposing (Translator)
import Inputs exposing (actionsMailbox)
import Forms.Model exposing (..)
import Forms.Update exposing (..)

import Views.Utils exposing (..)


view : Translator -> AppState -> Html
view t state =
  div [ class "content"]
    [ welcome t state
    , raceCourses t state
    ]

welcome : Translator -> AppState -> Html
welcome t {player,forms} =
  titleWrapper
    [ h1 [] [ text ("Welcome, " ++ (Maybe.withDefault "Anonymous" player.handle)) ]
    , setHandleBlock forms.setHandle
    ]

setHandleBlock : SetHandleForm -> Html
setHandleBlock form =
  row
    [ col4
      [ div [ class "input-group" ]
        [ textInput
          [ placeholder "Nickname?"
          , value form.handle
          , onInput actionsMailbox.address updateHandleField
          ]
        , span [ class "input-group-btn" ]
          [ button
            [ class "btn btn-primary"
            , onClick submitMailbox.address (SubmitSetHandle form)
            ]
            [ text "submit" ]
          ]
        ]
      ]
    ]

updateHandleField : String -> Inputs.Action
updateHandleField s =
  Inputs.FormAction (UpdateSetHandleForm (\f -> { f | handle <- s } ))

raceCourses : Translator -> AppState -> Html
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

