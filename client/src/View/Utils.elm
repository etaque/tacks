module View.Utils (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import String
import Signal
import TransitRouter
import Form
import Form.Error exposing (..)
import CoreExtra exposing (..)
import Constants exposing (..)
import Model.Shared exposing (..)
import Route


-- Events


linkTo : Route.Route -> List Attribute -> List Html -> Html
linkTo route attrs content =
  a ((linkAttrs route) ++ attrs) content


linkAttrs : Route.Route -> List Attribute
linkAttrs route =
  let
    path =
      Route.toPath route
  in
    [ href path
    , onPathClick path
    ]


onPathClick : String -> Attribute
onPathClick path =
  onWithOptions "click" eventOptions Json.value (\_ -> Signal.message TransitRouter.pushPathAddress path)


onButtonClick : Signal.Address a -> a -> Attribute
onButtonClick address action =
  onWithOptions "click" eventOptions Json.value (\_ -> Signal.message address action)


onInput : Signal.Address a -> (String -> a) -> Attribute
onInput address contentToValue =
  onWithOptions "input" eventOptions targetValue (\str -> Signal.message address (contentToValue str))


onIntInput : Signal.Address a -> (Int -> a) -> Attribute
onIntInput address contentToValue =
  onWithOptions "input" eventOptions intTargetValue (\str -> Signal.message address (contentToValue str))


intTargetValue : Json.Decoder Int
intTargetValue =
  Json.at [ "target", "value" ] (Json.customDecoder Json.string String.toInt)


onEnter : Signal.Address a -> a -> Attribute
onEnter address value =
  on
    "keydown"
    (Json.customDecoder keyCode isEnter)
    (\_ -> Signal.message address value)


eventOptions : Options
eventOptions =
  { stopPropagation = True
  , preventDefault = True
  }


isEnter : Int -> Result String ()
isEnter code =
  if code == 13 then
    Ok ()
  else
    Err "not the right key code"



-- Wrappers


type alias Wrapper =
  List Html -> Html


container : String -> Wrapper
container className content =
  div [ class ("container " ++ className) ] content


containerFluid : String -> Wrapper
containerFluid className content =
  div [ class ("container-fluid " ++ className) ] content


row : Wrapper
row content =
  div [ class "row" ] content


col' : Int -> List Html -> Html
col' i content =
  div [ class ("col-xs-" ++ toString i) ] content


fullWidth : Wrapper
fullWidth content =
  row [ div [ class "col-lg-12" ] content ]


hr' : Html
hr' =
  hr [] []


dl' : List ( String, List Html ) -> Html
dl' items =
  dl
    [ class "dl-horizontal" ]
    (List.concatMap (\( term, desc ) -> [ dt [] [ text term ], dd [] desc ]) items)


abbr' : String -> String -> Html
abbr' short long =
  abbr [ title long ] [ text short ]


icon : String -> Html
icon name =
  span [ class ("glyphicon glyphicon-" ++ name) ] []


fieldGroup : String -> String -> List String -> List Html -> Html
fieldGroup label' hint errors inputs =
  let
    feedbacksEl =
      div
        [ class "feedback" ]
        [ List.filter (not << String.isEmpty) (hint :: errors) |> String.join " - " |> text ]
  in
    div
      [ classList
          [ ( "form-group", True )
          , ( "with-error", not (List.isEmpty errors) )
          ]
      ]
      <| [ label [ class "control-label" ] [ text label' ] ]
      ++ inputs
      ++ [ feedbacksEl ]



-- fieldError : Maybe (Error e) -> Html
-- fieldError maybeError =
--   case maybeError of
--     Just e ->
--       div [ class "error-message" ] [ text (errorMessage e) ]
--     Nothing ->
--       div [ class "error-message empty" ] [ text "nope" ]


actionGroup : List Html -> Html
actionGroup content =
  row
    [ div [ class "col-xs-offset-3 col-xs-9" ] content ]


formGroup : Bool -> List Html -> Html
formGroup hasErr content =
  div
    [ classList [ ( "form-group", True ), ( "has-error", hasErr ) ] ]
    content


textInput : List Attribute -> Html
textInput attributes =
  input (List.append [ type' "text", class "form-control" ] attributes) []


passwordInput : List Attribute -> Html
passwordInput attributes =
  input (List.append [ type' "password", class "form-control" ] attributes) []



-- Components


playerWithAvatar : Player -> Html
playerWithAvatar player =
  let
    avatarImg =
      img [ src (avatarUrl player), class "avatar" ] []

    handleSpan =
      span [ class "handle" ] [ text (playerHandle player) ]
  in
    if player.guest then
      span [ class "player-avatar" ] [ avatarImg, text " ", handleSpan ]
    else
      span [ class "player-avatar" ] [ avatarImg, text " ", handleSpan ]


avatarUrl : Player -> String
avatarUrl p =
  case p.avatarId of
    Just id ->
      "/avatars/" ++ id

    Nothing ->
      if p.user then
        "/assets/images/avatar-user.png"
      else
        "/assets/images/avatar-guest.png"


playerHandle : Player -> String
playerHandle p =
  Maybe.withDefault "anonymous" p.handle


rankingItem : Ranking -> Html
rankingItem ranking =
  li
    [ class "ranking" ]
    [ span [ class "rank" ] [ text (toString ranking.rank) ]
    , span [ class "time" ] [ text (formatTimer True ranking.finishTime) ]
    , span [ class "handle" ] [ text (playerHandle ranking.player) ]
      -- , playerWithAvatar ranking.player
    ]


moduleTitle : String -> Html
moduleTitle title =
  div [ class "module-header" ] [ h3 [] [ text title ] ]



-- Misc


formatTimer : Bool -> Float -> String
formatTimer showMs t =
  let
    t' =
      t |> ceiling |> abs

    totalSeconds =
      t' // 1000

    minutes =
      totalSeconds // 60

    seconds =
      if showMs || t <= 0 then
        totalSeconds `rem` 60
      else
        (totalSeconds `rem` 60) + 1

    millis =
      t' `rem` 1000

    sMinutes =
      toString minutes

    sSeconds =
      String.padLeft 2 '0' (toString seconds)

    sMillis =
      if showMs then
        "." ++ (String.padLeft 3 '0' (toString millis))
      else
        ""
  in
    sMinutes ++ ":" ++ sSeconds ++ sMillis


colWidth : Int -> Float
colWidth col =
  (containerWidth + gutterWidth) / 12 * (toFloat col) - gutterWidth


errList : Maybe (Error e) -> List String
errList me =
  case me of
    Just e ->
      [ errMsg e ]

    Nothing ->
      []


errMsg : Error e -> String
errMsg e =
  case e of
    InvalidString ->
      "Required"

    Empty ->
      "Required"

    InvalidEmail ->
      "Invalid email format"

    InvalidUrl ->
      "Invalid URL format"

    InvalidFormat ->
      "Invalid format"

    InvalidInt ->
      "Invalid integer format"

    InvalidFloat ->
      "Invalid floating number format"

    ShorterStringThan i ->
      "At least " ++ toString i ++ " chars"

    _ ->
      toString e
