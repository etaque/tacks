module Page.EditTrack.View.Gates (..) where

import Signal
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Constants exposing (..)
import View.Utils as Utils exposing (..)
import Page.EditTrack.Update exposing (..)
import Page.EditTrack.Model exposing (..)
import Page.EditTrack.View.Utils exposing (..)
import Route


view : Maybe Int -> Course -> List Html
view currentGate { start, gates } =
  [ div
      [ class "list-gates" ]
      (List.indexedMap (gateItem (List.length gates) currentGate) (start :: gates))
  , button
      [ onClick formAddr AddGate
      , class "floating-button add-gate"
      ]
      [ Utils.mIcon "add" [] ]
  ]


gateItem : Int -> Maybe Int -> Int -> Gate -> Html
gateItem count currentGate i gate =
  let
    isStart =
      i == 0

    selectAction =
      -- if currentGate == Just i then
      --   SelectGate Nothing
      -- else
      SelectGate (Just i)

    name =
      if isStart then
        "Start"
      else
        "Gate " ++ toString i
  in
    div
      [ classList [ ( "gate", True ), ( "selected", currentGate == Just i ) ]
      , onClick addr selectAction
      ]
      [ div
          [ class "gate-header" ]
          [ div [ class "name" ] [ text name ]
          , orientationOptions (SetGateOrientation i) gate.orientation
          ]
      , div
          [ class "gate-fields" ]
          [ div
              [ class "form-group x" ]
              [ intInput ((round << fst) gate.center) (SetGateCenterX i) [ step "10" ]
              , label [] [ text "lat" ]
              ]
          , div
              [ class "form-group y" ]
              [ intInput ((round << snd) gate.center) (SetGateCenterY i) [ step "10" ]
              , label [] [ text "lon" ]
              ]
          , div
              [ class "form-group width" ]
              [ intInput (round gate.width) (SetGateWidth i) [ step "10" ]
              , label [] [ text "width" ]
              ]
          ]
      , if i == count && i /= 0 then
          div
            [ onClick formAddr (RemoveGate i)
            , class "remove"
            , title "Remove gate"
            ]
            [ mIcon "delete" [] ]
        else
          text ""
      ]


orientationOptions : (Orientation -> FormUpdate) -> Orientation -> Html
orientationOptions toMsg current =
  let
    item o =
      span
        [ onClick formAddr (toMsg o)
        , classList [ ( "orientation", True ), ( "current", o == current ) ]
        , title (orientationTitle o)
        ]
        [ Utils.mIcon (orientationIcon o) [] ]
  in
    div
      [ class "orientations" ]
      (List.map item [ North, South, East, West ])


orientationTitle : Orientation -> String
orientationTitle o =
  case o of
    North ->
      "Cross from south to north"

    South ->
      "Cross from north to south"

    East ->
      "Cross from west to east"

    West ->
      "Cross from east to west"


orientationIcon : Orientation -> String
orientationIcon o =
  case o of
    North ->
      "arrow_upward"

    South ->
      "arrow_downward"

    East ->
      "arrow_forward"

    West ->
      "arrow_back"
