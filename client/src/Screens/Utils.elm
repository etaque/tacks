module Screens.Utils where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import History
import String

import Models exposing (..)
import Game.Models exposing (..)
import Routes exposing (pathChangeMailbox)


type alias Wrapper = List Html -> Html


linkTo : String -> List Attribute -> List Html -> Html
linkTo path attrs content =
  let
    linkAttrs =
      [ href path
      , onPathClick pathChangeMailbox.address (History.setPath path)
      ]
  in
    a (linkAttrs ++ attrs) content

onPathClick : Signal.Address a -> a -> Attribute
onPathClick address msg =
  onWithOptions "click" eventOptions Json.value (\_ -> Signal.message address msg)

onInput : Signal.Address a -> (String -> a) -> Attribute
onInput address contentToValue =
  onWithOptions "input" eventOptions targetValue (\str -> Signal.message address (contentToValue str))

onIntInput : Signal.Address a -> (Int -> a) -> Attribute
onIntInput address contentToValue =
  onWithOptions "input" eventOptions intTargetValue (\str -> Signal.message address (contentToValue str))

intTargetValue : Json.Decoder Int
intTargetValue =
  Json.at ["target", "value"] (Json.customDecoder Json.string String.toInt)

onEnter : Signal.Address a -> a -> Attribute
onEnter address value =
    on "keydown"
      (Json.customDecoder keyCode is13)
      (\_ -> Signal.message address value)

eventOptions : Options
eventOptions =
  { stopPropagation = True
  , preventDefault = True
  }

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

formGroup : Bool -> List Html -> Html
formGroup hasErr content =
  div
    [ classList [ ("form-group", True), ("has-error", hasErr) ] ]
    content

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

sidebar : Dims -> Wrapper
sidebar (w, h) content =
  aside
    [ style
      [ ("height", toString h ++ "px")
      , ("width", toString w ++ "px")
      ]
    ]
    content


playerWithAvatar : Player -> Html
playerWithAvatar player =
  let
    avatarImg = img [ src (avatarUrl player), class "avatar" ] []
    handleSpan = span [ class "handle" ] [ text (playerHandle player) ]
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
  Maybe.withDefault "anonymous" p.handle

formatTimer : Bool -> Float -> String
formatTimer showMs t =
  let
    t' = t |> ceiling |> abs
    totalSeconds = t' // 1000
    minutes = totalSeconds // 60
    seconds = if showMs || t <= 0 then totalSeconds `rem` 60 else (totalSeconds `rem` 60) + 1
    millis = t' `rem` 1000
    sMinutes = toString minutes
    sSeconds = String.padLeft 2 '0' (toString seconds)
    sMillis = if showMs then "." ++ (String.padLeft 3 '0' (toString millis)) else ""
  in
    sMinutes ++ ":" ++ sSeconds ++ sMillis
