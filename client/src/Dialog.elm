module Dialog exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Svg
import Svg.Attributes as SvgAttr
import Transit exposing (Step(..), getValue, getStep)
import Keyboard


type Msg
  = NoOp
  | Close
  | KeyDown Int
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
  , closeOnEscape : Bool
  , onClose : Maybe Msg
  }


defaultOptions : Options
defaultOptions =
  { duration = 50
  , closeOnEscape = True
  , onClose = Nothing
  }


taggedOpen : (Msg -> msg) -> WithDialog model -> ( WithDialog model, Cmd msg )
taggedOpen tagger model =
  let
    ( newDialog, cmd ) =
      open model.dialog
  in
    ( { model | dialog = newDialog }, Cmd.map tagger cmd )


open : Model -> ( Model, Cmd Msg )
open model =
  Transit.start TransitMsg NoOp (0, model.options.duration) { model | open = True }


taggedUpdate : (Msg -> msg) -> Msg -> WithDialog model -> ( WithDialog model, Cmd msg )
taggedUpdate tagger msg model =
  let
    ( newDialog, cmd ) =
      update msg model.dialog
  in
    ( { model | dialog = newDialog }, Cmd.map tagger cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )

    KeyDown code ->
      if model.options.closeOnEscape && code == 27 && model.open then
        closeUpdate model
      else
        ( model, Cmd.none )

    Close ->
      closeUpdate model

    TransitMsg transitMsg ->
      Transit.tick TransitMsg transitMsg model


closeUpdate : Model -> ( Model, Cmd Msg )
closeUpdate model =
  Transit.start TransitMsg NoOp (model.options.duration, 0) { model | open = False }


subscriptions : Transit.WithTransition model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Keyboard.downs KeyDown
    , Transit.subscriptions TransitMsg model
    ]


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
    [ closeIcon ]


closeIcon : Svg.Svg msg
closeIcon =
  Svg.svg
    [ SvgAttr.width "24"
    , SvgAttr.height "24"
    ]
    [ Svg.path
        [ SvgAttr.d "M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z" ]
        []
    ]


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
        Transit.getValue transition

      _ ->
        0


display : Model -> String
display model =
  if isVisible model then
    "block"
  else
    "none"
