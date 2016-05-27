module View.Utils exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import String
import Form.Error exposing (..)
import Constants exposing (..)
import Model.Shared exposing (..)
import Route exposing (Route)
import Time exposing (Time)
import Date
import Date.Format as DateFormat


-- Events


linkTo : Route -> List (Attribute msg) -> List (Html msg) -> Html msg
linkTo route attrs content =
  a ((linkAttrs route) ++ attrs) content


linkAttrs : Route -> List (Attribute msg)
linkAttrs route =
  let
    path =
      Route.toPath route
  in
    [ href path
    , attribute "data-navigate" path
    ]


onButtonClick : msg -> Attribute msg
onButtonClick msg =
  onWithOptions "click" eventOptions (Json.map (\_ -> msg) Json.value)


onIntInput : (Int -> msg) -> Attribute msg
onIntInput tagger =
  onWithOptions "input" eventOptions (Json.map tagger intTargetValue)


intTargetValue : Json.Decoder Int
intTargetValue =
  Json.at [ "target", "value" ] (Json.customDecoder Json.string String.toInt)


onEnter : msg -> Attribute msg
onEnter msg =
  on
    "keydown"
    (Json.map (\_ -> msg) (Json.customDecoder keyCode isEnter))


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


type alias Wrapper msg =
  List (Html msg) -> Html msg


container : String -> Wrapper msg
container className content =
  div [ class ("container " ++ className) ] content


-- containerFluid : String -> Wrapper msg
-- containerFluid className content =
--   div [ class ("container-fluid " ++ className) ] content


-- row : Wrapper
-- row content =
--   div [ class "row" ] content


-- col' : Int -> List Html -> Html
-- col' i content =
--   div [ class ("col-xs-" ++ toString i) ] content


-- fullWidth : Wrapper
-- fullWidth content =
--   row [ div [ class "col-lg-12" ] content ]


hr' : Html msg
hr' =
  hr [] []


-- dl' : List ( String, List (Html msg) ) -> Html msg
-- dl' items =
--   dl
--     [ class "dl-horizontal" ]
--     (List.concatMap (\( term, desc ) -> [ dt [] [ text term ], dd [] desc ]) items)


abbr' : String -> String -> Html msg
abbr' short long =
  abbr [ title long ] [ text short ]


-- icon : String -> Html msg
-- icon name =
--   span [ class ("glyphicon glyphicon-" ++ name) ] []


mIcon : String -> List String -> Html msg
mIcon name classes =
  i
    [ class ("material-icons" :: classes |> String.join " ") ]
    [ text name ]


nbsp : Html msg
nbsp =
  text " "


formatDate : Time -> String
formatDate time =
  DateFormat.format "%e %b. %k:%M" (Date.fromTime time)


fieldGroup : String -> String -> String -> List String -> List (Html msg) -> Html msg
fieldGroup id label' hint errors inputs =
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
      (inputs ++ [ label [ class "control-label", for id ] [ text label' ], feedbacksEl ])



-- fieldError : Maybe (Error e) -> Html
-- fieldError maybeError =
--   case maybeError of
--     Just e ->
--       div [ class "error-message" ] [ text (errorMessage e) ]
--     Nothing ->
--       div [ class "error-message empty" ] [ text "nope" ]


-- actionGroup : List (Html msg) -> Html msg
-- actionGroup content =
--   row
--     [ div [ class "col-xs-offset-3 col-xs-9" ] content ]


formGroup : Bool -> List (Html msg) -> Html msg
formGroup hasErr content =
  div
    [ classList [ ( "form-group", True ), ( "has-error", hasErr ) ] ]
    content


textInput : List (Attribute msg) -> Html msg
textInput attributes =
  input (List.append [ type' "text", class "form-control" ] attributes) []


passwordInput : List (Attribute msg) -> Html msg
passwordInput attributes =
  input (List.append [ type' "password", class "form-control" ] attributes) []



-- Components


playerWithAvatar : Player -> Html msg
playerWithAvatar player =
  span
    [ class "player-avatar" ]
    [ img [ src (avatarUrl 32 player), class "avatar" ] []
    , text " "
    , span [ class "handle" ] [ text (playerHandle player) ]
    ]


avatarUrl : Int -> Player -> String
avatarUrl size p =
  case p.avatarId of
    Just id ->
      "http://www.gravatar.com/avatar/"
        ++ id
        ++ "?s="
        ++ toString size
        ++ "&d=http://www.playtacks.com/assets/images/avatar-guest.png"

    Nothing ->
      if p.user then
        "/assets/images/avatar-user.png"
      else
        "/assets/images/avatar-guest.png"


playerHandle : Player -> String
playerHandle p =
  Maybe.withDefault "anonymous" p.handle


rankingItem : Ranking -> Html msg
rankingItem ranking =
  li
    [ class "ranking" ]
    [ span [ class "rank" ] [ text (toString ranking.rank) ]
    , span [ class "time" ] [ text (formatTimer True ranking.finishTime) ]
      -- , span [ class "handle" ] [ text (playerHandle ranking.player) ]
    , playerWithAvatar ranking.player
    ]


moduleTitle : String -> Html msg
moduleTitle title =
  div [ class "module-header" ] [ h3 [] [ text title ] ]


tabsRow : List ( String, tab ) -> (tab -> (Attribute msg)) -> (tab -> Bool) -> Html msg
tabsRow items toAttr isSelected =
  div
    [ class "tabs-container" ]
    [ div
        [ class "tabs-content" ]
        (List.map (tabItem toAttr isSelected) items)
    ]


tabItem : (tab -> Attribute msg) -> (tab -> Bool) -> ( String, tab ) -> Html msg
tabItem toAttr isSelected ( title, tab ) =
  div
    [ classList
        [ ( "tab", True )
        , ( "tab-selected", isSelected tab )
        ]
    , toAttr tab
    ]
    [ text title ]



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
