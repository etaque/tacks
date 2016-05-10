module Dialog (..) where

import Signal exposing (Address, Message)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Transit exposing (Status(..), getValue, getStatus)
import Task exposing (Task)
import Effects exposing (Effects, Never, none)
import CoreExtra
import Response
import View.Utils as Utils


type Action
  = NoOp
  | Open
  | Close
  | TransitAction (Transit.Action Action)


type alias Model =
  Transit.WithTransition
    { open : Bool
    , options : Options
    }


type alias WithDialog a =
  { a | dialog : Model }


initial : Model
initial =
  { transition = Transit.initial
  , open = False
  , options = defaultOptions
  }


type alias Options =
  { duration : Float
  , onClose : Maybe Message
  }


defaultOptions : Options
defaultOptions =
  { duration = 50
  , onClose = Nothing
  }


taggedOpen : (Action -> a) -> WithDialog m -> ( WithDialog m, Effects a )
taggedOpen tagger model =
  open model.dialog
    |> Response.mapBoth (\newDialog -> { model | dialog = newDialog }) tagger


open : Model -> ( Model, Effects Action )
open model =
  Response.taskRes model (Task.succeed Open)


taggedUpdate : (Action -> a) -> Action -> WithDialog m -> ( WithDialog m, Effects a )
taggedUpdate tagger action model =
  update action model.dialog
    |> Response.mapBoth (\newDialog -> { model | dialog = newDialog }) tagger


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NoOp ->
      ( model, none )

    Open ->
      let
        timeline =
          Transit.timeline 0 NoOp model.options.duration

        newModel =
          { model | open = True }
      in
        Transit.init TransitAction timeline newModel

    Close ->
      let
        timeline =
          Transit.timeline model.options.duration NoOp 0

        newModel =
          { model | open = False }
      in
        Transit.init TransitAction timeline newModel

    TransitAction transitAction ->
      Transit.update TransitAction transitAction model


type alias Layout =
  { header : List Html
  , body : List Html
  , footer : List Html
  }


emptyLayout : Layout
emptyLayout =
  Layout [] [] []


view : Address Action -> Model -> Layout -> Html
view addr model layout =
  div
    [ class "dialog-wrapper"
    , style
        [ ( "display", display model )
        , ( "opacity", toString (opacity model) )
        ]
    , onClick addr Close
    ]
    [ div
        [ class "dialog-sheet" ]
        [ if List.isEmpty layout.header then
            text ""
          else
            div
              [ class "dialog-header" ]
              (closeButton addr :: layout.header)
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


closeButton : Address Action -> Html
closeButton addr =
  span
    [ class
        "dialog-close"
    , onClick addr Close
    ]
    [ Utils.mIcon "close" [] ]


title : String -> Html
title s =
  div [ class "dialog-title" ] [ text s ]


subtitle : String -> Html
subtitle s =
  div [ class "dialog-subtitle" ] [ text s ]


isVisible : Model -> Bool
isVisible { open, transition } =
  open || Transit.getStatus transition == Exit


opacity : Model -> Float
opacity { open, transition } =
  if open then
    case Transit.getStatus transition of
      Exit ->
        0

      Enter ->
        Transit.getValue transition

      Done ->
        1
  else
    case Transit.getStatus transition of
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
