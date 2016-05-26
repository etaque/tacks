module Dialog exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Transit exposing (Step(..), getValue, getStep)
import Response exposing (..)
import View.Utils as Utils
import CoreExtra


type Msg
  = NoOp
  | Open
  | Close
  | TransitMsg (Transit.Msg Msg)


type alias Model =
  Transit.WithTransition
    { open : Bool
    , options : Options
    }


type alias WithDialog a =
  { a | dialog : Model }


initial : Model
initial =
  { transition = Transit.empty
  , open = False
  , options = defaultOptions
  }


type alias Options =
  { duration : Float
  , onClose : Maybe Msg
  }


defaultOptions : Options
defaultOptions =
  { duration = 50
  , onClose = Nothing
  }


taggedOpen : (Msg -> msg) -> WithDialog model -> Response (WithDialog model) msg
taggedOpen tagger model =
  open model.dialog
    |> Response.mapBoth (\newDialog -> { model | dialog = newDialog }) tagger


open : Model -> Response Model Msg
open model =
  res model (CoreExtra.toCmd Open)


taggedUpdate : (Msg -> msg) -> Msg -> WithDialog model -> Response (WithDialog model) msg
taggedUpdate tagger msg model =
  update msg model.dialog
    |> Response.mapBoth (\newDialog -> { model | dialog = newDialog }) tagger


update : Msg -> Model -> Response Model Msg
update msg model =
  case msg of
    NoOp ->
      res model Cmd.none

    Open ->
      let
        newModel =
          { model | open = True }
      in
        Transit.start TransitMsg NoOp (0, model.options.duration) newModel
          |> pure

    Close ->
      let
        newModel =
          { model | open = False }
      in
        Transit.start TransitMsg NoOp (model.options.duration, 0) newModel
          |> pure

    TransitMsg transitMsg ->
      Transit.tick TransitMsg transitMsg model
        |> pure


type alias Layout =
  { header : List (Html Msg)
  , body : List (Html Msg)
  , footer : List (Html Msg)
  }


emptyLayout : Layout
emptyLayout =
  Layout [] [] []


type alias View msg =
  { content : Html msg
  , backdrop : Html msg
  }

view : (Msg -> msg) -> Model -> Layout -> View msg
view tagger model layout =
  { content = Html.map tagger <|
      div
        [ class "dialog-wrapper"
        , style
            [ ( "display", display model )
            , ( "opacity", toString (opacity model) )
            ]
        , onClick Close
        ]
        [ div
            [ class "dialog-sheet" ]
            [ if List.isEmpty layout.header then
                text ""
              else
                div
                  [ class "dialog-header" ]
                  (closeButton :: layout.header)
            , div
                [ class "dialog-body" ]
                layout.body
            , if List.isEmpty layout.footer then
                text ""
              else
                div
                  [ class "dialog-footer" ]
                  layout.footer
            ]
        ]
  , backdrop = Html.map tagger <|
      div [ class "dialog-backdrop" ] []
  }


closeButton : Html Msg
closeButton =
  span
    [ class "dialog-close"
    , onClick Close
    ]
    [ Utils.mIcon "close" [] ]


title : String -> Html Msg
title s =
  div [ class "dialog-title" ] [ text s ]


subtitle : String -> Html Msg
subtitle s =
  div [ class "dialog-subtitle" ] [ text s ]


isVisible : Model -> Bool
isVisible { open, transition } =
  open || Transit.getStep transition == Exit


opacity : Model -> Float
opacity { open, transition } =
  if open then
    case Transit.getStep transition of
      Exit ->
        0

      Enter ->
        Transit.getValue transition

      Done ->
        1
  else
    case Transit.getStep transition of
      Exit ->
        1 - Transit.getValue transition

      _ ->
        0


display : Model -> String
display model =
  if isVisible model then
    "block"
  else
    "none"
