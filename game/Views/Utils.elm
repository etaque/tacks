module Views.Utils where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import State exposing (..)
import Game exposing (..)
import Messages exposing (Translator)
import Inputs exposing (actionsMailbox)

clickTo : Screen -> Attribute
clickTo screen =
  onClick actionsMailbox.address (Inputs.Navigate screen)

onInput : Signal.Address a -> (String -> a) -> Attribute
onInput address contentToValue =
    on "input" targetValue (\str -> Signal.message address (contentToValue str))

row : List Html -> Html
row content =
  div [ class "row" ] content

col4 = col 4

col : Int -> List Html -> Html
col w content =
  let
    ws = toString w
  in
    div [ class ("col-lg-" ++ ws ++ " col-lg-offset-" ++ ws) ] content

textInput : List Attribute -> Html
textInput attributes =
  input (List.append [ type' "text", class "form-control"] attributes) []

titleWrapper : List Html -> Html
titleWrapper content =
  blockWrapper "title-wrapper" content

lightWrapper : List Html -> Html
lightWrapper content =
  blockWrapper "light-wrapper" content

blockWrapper : String -> List Html -> Html
blockWrapper wrapperClass content =
  div [ class wrapperClass ] [ div [ class "container" ] content ]


playerWithAvatar : Player -> Html
playerWithAvatar player =
  let
    avatarUrl = case player.avatarId of
      Just id -> "/avatars/" ++ id
      Nothing -> if player.user then "/assets/images/avatar-user.png" else "/assets/images/avatar-guest.png"
    avatarImg = img [ src avatarUrl, class "avatar", width 19, height 19 ] []
    handleSpan = span [ class "handle" ] [ text (Maybe.withDefault "Anonymous" player.handle) ]
    handle = Maybe.withDefault "" player.handle
  in
    if player.guest
      then
        span [ class "player-avatar" ] [avatarImg, text " ", handleSpan]
      else
        a [ href ("/players/" ++ handle), target "_blank", class "player-avatar" ] [avatarImg, text " ", handleSpan]

raceCourseName : Translator -> RaceCourse -> String
raceCourseName t {slug} =
  t <| "generators." ++ slug ++ ".name"
