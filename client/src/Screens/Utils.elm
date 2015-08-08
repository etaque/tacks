module Screens.Utils where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import History

import Models exposing (..)
import Game.Models exposing (..)
import Routes exposing (pathChangeMailbox)


type alias Wrapper = List Html -> Html


path : String -> Attribute
path p =
  onClick pathChangeMailbox.address (History.setPath p)

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

container : Wrapper
container content =
  div [ class "container" ] content

row : Wrapper
row content =
  div [ class "row" ] content

col4 : Wrapper
col4 content =
  div [ class "col-lg-4 col-lg-offset-4" ] content

whitePanel : Wrapper
whitePanel content =
  col4 [ div [ class "white-panel" ] content ]

textInput : List Attribute -> Html
textInput attributes =
  input (List.append [ type' "text", class "form-control"] attributes) []

passwordInput : List Attribute -> Html
passwordInput attributes =
  input (List.append [ type' "password", class "form-control"] attributes) []

titleWrapper : Wrapper
titleWrapper content =
  blockWrapper "title-wrapper" content

lightWrapper : Wrapper
lightWrapper content =
  blockWrapper "light-wrapper" content

blockWrapper : String -> Wrapper
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
        span [ class "player-avatar" ] [avatarImg, text " ", handleSpan]

avatarUrl : Player -> String
avatarUrl p =
  case p.avatarId of
    Just id -> "/avatars/" ++ id
    Nothing -> if p.user then "/assets/images/avatar-user.png" else "/assets/images/avatar-guest.png"

playerHandle : Player -> String
playerHandle p =
  Maybe.withDefault "Anonymous" p.handle
