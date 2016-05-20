module Page.EditTrack.View.Gusts exposing (..)

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Page.EditTrack.Model exposing (..)
import Page.EditTrack.View.Utils exposing (..)


view : Track -> Editor -> List (Html FormMsg)
view track ({ tab, course, name, saving, mode } as editor) =
  [ div
      [ class "gusts-fields" ]
      [ div
          [ class "form-group" ]
          [ intInput
              course.gustGenerator.interval
              (\i -> UpdateGustGen (\gen -> { gen | interval = i }))
              [ HtmlAttr.min "10" ]
          , label [ class "" ] [ text "Spawn interval (s)" ]
          ]
      , div
          [ class "form-group" ]
          [ intInput
              course.gustGenerator.radiusBase
              (\i -> UpdateGustGen (\gen -> { gen | radiusBase = i }))
              [ HtmlAttr.min "50", HtmlAttr.step "10", HtmlAttr.max "1000" ]
          , label [ class "" ] [ text "Average radius" ]
          ]
      , div
          [ class "form-group" ]
          [ intInput
              course.gustGenerator.radiusVariation
              (\i -> UpdateGustGen (\gen -> { gen | radiusVariation = i }))
              [ HtmlAttr.min "0", HtmlAttr.step "10", HtmlAttr.max "500" ]
          , label [ class "" ] [ text "Radius variation (+/-)" ]
          ]
      , div
          [ class "form-group range" ]
          [ div
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
          , label [ class "" ] [ text "Wind speed variation range" ]
          ]
      , div
          [ class "form-group range" ]
          [ div
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
          , label [ class "" ] [ text "Wind origin variation range" ]
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
