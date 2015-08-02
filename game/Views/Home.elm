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
  titleWrapper <| List.append
    [ h1 [] [ text ("Welcome, " ++ (Maybe.withDefault "Anonymous" player.handle)) ] ]
    (welcomeForms player forms)

welcomeForms : Player -> Forms -> List Html
welcomeForms player forms =
  if player.guest then
    [ setHandleBlock forms.setHandle
    , loginBlock forms.login
    ]
  else
    []

setHandleBlock : SetHandleForm -> Html
setHandleBlock form =
  row
    [ col4
      [ div [ class "input-group" ]
        [ textInput
          [ placeholder "Nickname?"
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


loginBlock : LoginForm -> Html
loginBlock form =
  row
    [ col4
      [ div [ class "form-group" ]
        [ textInput
          [ placeholder "Email"
          , value form.email
          , onInputFormUpdate (\s -> UpdateLoginForm (\f -> { f | email <- s } ))
          ]
        ]
      , div [ class "form-group" ]
        [ passwordInput
          [ placeholder "Password"
          , value form.password
          , onInputFormUpdate (\s -> UpdateLoginForm (\f -> { f | password <- s } ))
          ]
        ]
      , div []
        [ button
          [ class "btn btn-primary"
          , onClick submitMailbox.address (SubmitLogin form)
          ]
          [ text "Submit" ]
        ]
      ]
    ]


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
        [ onClickGoTo (Show rcs) ]
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

