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
  div [ class "home"]
    [ welcome t state
    , raceCourses t state
    ]

welcome : Translator -> AppState -> Html
welcome t {player,forms} =
  titleWrapper <| List.append
    [ h1 [] [ text ("Welcome, " ++ (Maybe.withDefault "Anonymous" player.handle)) ] ]
    (welcomeForms player forms)

welcomeForms : Player -> Forms -> List Html
welcomeForms player forms =
  if player.guest then
    [ setHandleBlock forms.setHandle ]
  else
    []

setHandleBlock : SetHandleForm -> Html
setHandleBlock form =
  div [ class "row form-set-handle" ]
    [ col4
      [ div [ class "input-group" ]
        [ textInput
          [ placeholder "Got a nickname?"
          , value form.handle
          , onInputFormUpdate (\s -> UpdateSetHandleForm (\f -> { f | handle <- s } ))
          , onEnter submitMailbox.address (SubmitSetHandle form)
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


raceCourses : Translator -> AppState -> Html
raceCourses t state =
  div [ class "container" ]
    [ div [ class "row" ] [ p [ class "align-center upclassic" ] [ text "Choose your track" ] ]
    , div [ class "row" ] (List.map (raceCourseStatusBlock t) state.courses)
    ]

raceCourseStatusBlock : Translator -> RaceCourseStatus -> Html
raceCourseStatusBlock t ({raceCourse,opponents} as rcs) =
  div [ class "col-md-4" ]
    [ div [ class "race-course-status" ]
      [ a
        [ class "show"
        , style [ ("background-image", "url(/assets/images/trials-" ++ raceCourse.slug ++ ".png)") ]
        , onClickGoTo (Show rcs)
        ]
        [ span [ class "name" ] [ text (raceCourseName t raceCourse) ]
        , div [ class "description"] [ text (t ("generators." ++ raceCourse.slug ++ ".description"))]
        ]
      , opponentsList opponents
      ]
    ]

opponentsList : List Opponent -> Html
opponentsList opponents =
  ul [ class "race-course-opponents" ] (List.map opponentItem opponents)

opponentItem : Opponent -> Html
opponentItem {player,state} =
  li [ class "opponent" ] [ playerWithAvatar player ]

