module Page.EditTrack.View.Wind exposing (..)

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)
import Page.EditTrack.Model exposing (..)
import Page.EditTrack.View.Utils exposing (..)
import Page.EditTrack.View.WindGraph as WindGraph


view : Editor -> List (Html FormMsg)
view ({ course, windSimDuration } as editor) =
  [ div
      [ class "wind-fields" ]
      [ div
          [ class "form-group filled" ]
          [ intInput course.windSpeed SetWindSpeed [ HtmlAttr.min "10", HtmlAttr.max "20" ]
          , label [ class "" ] [ text "Speed" ]
          ]
      , div
          [ class "form-row" ]
          [ div
              [ class "form-group" ]
              [ intInput course.windGenerator.wavelength1 SetWindW1 [ HtmlAttr.min "1" ]
              , label [ class "" ] [ text "Wavelength 1" ]
              ]
          , div
              [ class "form-group" ]
              [ intInput course.windGenerator.amplitude1 SetWindA1 [ HtmlAttr.min "1" ]
              , label [ class "" ] [ text "Amplitude 1" ]
              ]
          ]
      , div
          [ class "form-row" ]
          [ div
              [ class "form-group" ]
              [ intInput course.windGenerator.wavelength2 SetWindW2 [ HtmlAttr.min "1" ]
              , label [ class "" ] [ text "Wavelength 2" ]
              ]
          , div
              [ class "form-group" ]
              [ intInput course.windGenerator.amplitude2 SetWindA2 [ HtmlAttr.min "1" ]
              , label [ class "" ] [ text "Amplitude 2" ]
              ]
          ]
      ]
  , div
      [ class "wind-graph" ]
      [ div
          [ class "wind-sim-duration pull-right" ]
          [ span
              [ classList [ ( "selected", windSimDuration == TenMin ) ]
              , onClick (SetWindSimDuration TenMin)
              ]
              [ text "10min" ]
          , span
              [ classList [ ( "selected", windSimDuration == OneHour ) ]
              , onClick (SetWindSimDuration OneHour)
              ]
              [ text "1h" ]
          ]
      , h3 [] [ text "Simulation" ]
      , WindGraph.render editor
      ]
  ]
