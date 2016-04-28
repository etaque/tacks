module Page.EditTrack.View.Gusts (..) where

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


view : Track -> Editor -> List Html
view track ({ tab, course, name, saving, mode } as editor) =
  [ div
      [ class "gusts-fields" ]
      [ div
          [ class "form-group" ]
          [ label [ class "" ] [ text "Spawn interval (s)" ]
          , intInput
              course.gustGenerator.interval
              (\i -> UpdateGustGen (\gen -> { gen | interval = i }))
              [ HtmlAttr.min "10" ]
          ]
      , div
          [ class "form-group" ]
          [ label [ class "" ] [ text "Average radius" ]
          , intInput
              course.gustGenerator.radiusBase
              (\i -> UpdateGustGen (\gen -> { gen | radiusBase = i }))
              [ HtmlAttr.min "50", HtmlAttr.step "10", HtmlAttr.max "1000" ]
          ]
      , div
          [ class "form-group" ]
          [ label [ class "" ] [ text "Radius variation (+/-)" ]
          , intInput
              course.gustGenerator.radiusVariation
              (\i -> UpdateGustGen (\gen -> { gen | radiusVariation = i }))
              [ HtmlAttr.min "0", HtmlAttr.step "10", HtmlAttr.max "500" ]
          ]
      , div
          [ class "form-group range" ]
          [ label [ class "" ] [ text "Wind speed variation range" ]
          , div
              [ class "inline-fields" ]
              [ intInput
                  course.gustGenerator.speedVariation.start
                  (UpdateGustGen << updateSpeedVariation << updateRangeStart)
                  [ HtmlAttr.min "-10", HtmlAttr.step "1", HtmlAttr.max "0" ]
              , intInput
                  course.gustGenerator.speedVariation.end
                  (UpdateGustGen << updateSpeedVariation << updateRangeEnd)
                  [ HtmlAttr.min "0", HtmlAttr.step "1", HtmlAttr.max "10" ]
              ]
          ]
      , div
          [ class "form-group range" ]
          [ label [ class "" ] [ text "Wind origin variation range" ]
          , div
              [ class "inline-fields" ]
              [ intInput
                  course.gustGenerator.originVariation.start
                  (UpdateGustGen << updateOriginVariation << updateRangeStart)
                  [ HtmlAttr.min "-20", HtmlAttr.step "1", HtmlAttr.max "0" ]
              , intInput
                  course.gustGenerator.originVariation.end
                  (UpdateGustGen << updateOriginVariation << updateRangeEnd)
                  [ HtmlAttr.min "0", HtmlAttr.step "1", HtmlAttr.max "20" ]
              ]
          ]
      ]
  ]


updateRangeStart start range =
  { range | start = start }


updateRangeEnd end range =
  { range | end = end }


updateSpeedVariation : (Range -> Range) -> GustGenerator -> GustGenerator
updateSpeedVariation updateRange ({ speedVariation } as gen) =
  { gen | speedVariation = updateRange speedVariation }


updateOriginVariation : (Range -> Range) -> GustGenerator -> GustGenerator
updateOriginVariation updateRange ({ originVariation } as gen) =
  { gen | originVariation = updateRange originVariation }
