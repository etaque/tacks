module Screens.Utils where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import String
import Signal
import TransitRouter

import Constants exposing (..)
import Models exposing (..)
import Routes


-- Events

linkTo : Routes.Route -> List Attribute -> List Html -> Html
linkTo route attrs content =
  let
    path = Routes.toPath route
    linkAttrs =
      [ href path
      , onPathClick path
      ]
  in
    a (linkAttrs ++ attrs) content

onPathClick : String -> Attribute
onPathClick path =
  onWithOptions "click" eventOptions Json.value (\_ -> Signal.message TransitRouter.pushPathAddress path)

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
    (Json.customDecoder keyCode isEnter)
    (\_ -> Signal.message address value)

eventOptions : Options
eventOptions =
  { stopPropagation = True
  , preventDefault = True
  }

isEnter : Int -> Result String ()
isEnter code =
  if code == 13 then Ok () else Err "not the right key code"


-- Wrappers

type alias Wrapper = List Html -> Html

container : String -> Wrapper
container className content =
  div [ class ("container " ++ className) ] content

containerFluid : String -> Wrapper
containerFluid className content =
  div [ class ("container-fluid " ++ className) ] content

row : Wrapper
row content =
  div [ class "row" ] content

fullWidth : Wrapper
fullWidth content =
  row [ div [ class "col-lg-12" ] content ]

hr' : Html
hr' =
  hr [] []

dl' : List (String, List Html) -> Html
dl' items =
  dl [ class "dl-horizontal" ] (List.concatMap (\(term, desc) -> [ dt [] [ text term ], dd [] desc ]) items)

abbr' : String -> String -> Html
abbr' short long =
  abbr [ title long ] [ text short ]

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


-- Components

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

rankingItem : Ranking -> Html
rankingItem ranking =
  li [ class "ranking" ]
    [ span [ class "rank" ] [ text (toString ranking.rank)]
    , span [ class "status" ] [ text (formatTimer True ranking.finishTime) ]
    , span [ class "handle" ] [ text (playerHandle ranking.player) ]
    -- , playerWithAvatar ranking.player
    ]

moduleTitle : String -> Html
moduleTitle title =
  div [ class "module-header" ] [ h3 [ ] [ text title ] ]

-- Misc

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


colWidth : Int -> Float
colWidth col =
  (containerWidth + gutterWidth) / 12 * (toFloat col) - gutterWidth
