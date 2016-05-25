port module Location exposing (..)

import Transit
import Route exposing (Route)
import Response exposing (..)
import Model.Event as Event
import Json.Decode as Json
import Json.Decode.Extra exposing (lazy)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)


port setPath : String -> Cmd msg


port pathUpdates : (String -> msg) -> Sub msg


type Msg
  = SetPath String
  | PathUpdated String
  | PathTransition (Transit.Msg Msg)
  | EventRoute Route


type alias Model = Transit.WithTransition
  { route : Route
  , routeJump : Route.RouteJump
  }


initial : Model
initial =
  { route = Route.EmptyRoute
  , routeJump = Route.None
  , transition = Transit.empty
  }


subscriptions : (Msg -> msg) -> Model -> Sub msg
subscriptions tagger model =
  Sub.batch
    [ pathUpdates PathUpdated
    , Transit.subscriptions PathTransition model
    ] |> Sub.map tagger


update : Msg -> Model -> Response Model Msg
update msg model =
  case msg of
    SetPath path ->
      res model (setPath path)

    PathUpdated path ->
      let
        newRoute = Route.fromPath path
      in
        Transit.start PathTransition (EventRoute newRoute) (50, 200) model
          |> pure

    PathTransition subMsg ->
      Transit.tick PathTransition subMsg model
        |> pure

    EventRoute route ->
      res { model | route = route } Cmd.none
        |> withEvent (Event.MountRoute model.route route)


navigate : Route -> Cmd msg
navigate route =
  setPath (Route.toPath route)


catchNavigationClicks : (String -> msg) -> Attribute msg
catchNavigationClicks tagger =
  onWithOptions
    "click"
    { stopPropagation = True
    , preventDefault = True
    }
    (Json.map tagger (Json.at [ "target" ] pathDecoder))


pathDecoder : Json.Decoder String
pathDecoder =
  Json.oneOf
    [ Json.at [ "dataset", "navigate" ] Json.string
    , Json.at [ "data-navigate" ] Json.string
    , Json.at [ "parentElement" ] (lazy (\_ -> pathDecoder))
    , Json.fail "no path found for click"
    ]


linkAttrs : Route -> List (Attribute msg)
linkAttrs route =
  let
    path =
      Route.toPath route
  in
    [ href path
    , attribute "data-navigate" path
    ]
