module Views.Utils where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import History exposing (setPath)

import State exposing (..)
import Game exposing (..)
import Messages exposing (Translator)
import Inputs exposing (actionsMailbox)
import Forms.Model exposing (UpdateForm)
import Routes exposing (pathChangeMailbox)


path : String -> Attribute
path p =
  onClick pathChangeMailbox.address (setPath p)


onInputFormUpdate : (String -> UpdateForm) -> Attribute
onInputFormUpdate updater =
  onInput actionsMailbox.address (updater >> Inputs.FormAction)

onInput : Signal.Address a -> (String -> a) -> Attribute
onInput address contentToValue =
    on "input" targetValue (\str -> Signal.message address (contentToValue str))

onEnter : Signal.Address a -> a -> Attribute
onEnter address value =
    on "keydown"
      (Json.customDecoder keyCode is13)
      (\_ -> Signal.message address value)

is13 : Int -> Result String ()
is13 code =
  if code == 13 then Ok () else Err "not the right key code"

container : List Html -> Html
container content =
  div [ class "container" ] content

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

passwordInput : List Attribute -> Html
passwordInput attributes =
  input (List.append [ type' "password", class "form-control"] attributes) []

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
    avatarImg = img [ src (avatarUrl player), class "avatar", width 19, height 19 ] []
    handleSpan = span [ class "handle" ] [ text (Maybe.withDefault "Anonymous" player.handle) ]
    handle = Maybe.withDefault "" player.handle
  in
    if player.guest
      then
        span [ class "player-avatar" ] [avatarImg, text " ", handleSpan]
      else
        a [ href ("/players/" ++ handle), target "_blank", class "player-avatar" ] [avatarImg, text " ", handleSpan]

avatarUrl : Player -> String
avatarUrl p =
  case p.avatarId of
    Just id -> "/avatars/" ++ id
    Nothing -> if p.user then "/assets/images/avatar-user.png" else "/assets/images/avatar-guest.png"

playerHandle : Player -> String
playerHandle p =
  Maybe.withDefault "Anonymous" p.handle

raceCourseName : Translator -> RaceCourse -> String
raceCourseName t {slug} =
  t <| "generators." ++ slug ++ ".name"
