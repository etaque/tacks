module Page.EditTrack.SideView (..) where

import Signal
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Constants exposing (..)
import View.Utils exposing (..)
import Page.EditTrack.Update exposing (..)
import Page.EditTrack.Model exposing (..)
import View.Sidebar as Sidebar
import Game.Render.Tiles as RenderTiles exposing (tileKindColor)
import Route


formAddr : Signal.Address FormUpdate
formAddr =
  Signal.forwardTo addr FormAction


nav : Track -> Editor -> List Html
nav track editor =
  [ h2
      []
      [ linkTo
          (Route.ShowTrack track.id)
          []
          [ text track.name ]
      ]
  ]


toolbar : Track -> Editor -> Html
toolbar track editor =
  div
    [ class "toolbar"
    , onMouseOver addr (HoverToolbar True)
    , onMouseOut addr (HoverToolbar False)
    ]
    [ surfaceBlock editor
    ]


view : Track -> Editor -> List Html
view track ({ course, name, saving, mode, blocks } as editor) =
  [ sideBlock
      "Name"
      blocks.name
      (ToggleBlock Name)
      [ div
          [ class "form-group" ]
          [ textInput
              [ value name
              , onInput addr SetName
              , type' "text"
              ]
          ]
      ]
  , sideBlock
      "Surface pencil"
      blocks.surface
      (ToggleBlock Surface)
      [ surfaceBlock editor
      , p [] [ text "Press SHIFT for temporary move mode" ]
      ]
  , sideBlock
      "Gates"
      blocks.gates
      (ToggleBlock Gates)
      (renderGatesGroups course)
  , sideBlock
      "Wind"
      blocks.wind
      (ToggleBlock Wind)
      [ div
          [ class "form-group" ]
          [ label [ class "" ] [ text "Speed" ]
          , intInput course.windSpeed SetWindSpeed [ HtmlAttr.min "10", HtmlAttr.max "20" ]
          ]
      , div
          [ class "form-group" ]
          [ label [ class "" ] [ text "Wavelength 1" ]
          , intInput course.windGenerator.wavelength1 SetWindW1 [ HtmlAttr.min "1" ]
          ]
      , div
          [ class "form-group" ]
          [ label [ class "" ] [ text "Amplitude 1" ]
          , intInput course.windGenerator.amplitude1 SetWindA1 [ HtmlAttr.min "1" ]
          ]
      , div
          [ class "form-group" ]
          [ label [ class "" ] [ text "Wavelength 2" ]
          , intInput course.windGenerator.wavelength2 SetWindW2 [ HtmlAttr.min "1" ]
          ]
      , div
          [ class "form-group" ]
          [ label [ class "" ] [ text "Amplitude 2" ]
          , intInput course.windGenerator.amplitude2 SetWindA2 [ HtmlAttr.min "1" ]
          ]
      ]
  , sideBlock
      "Gusts"
      blocks.gusts
      (ToggleBlock Gusts)
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
          [ label [ class "" ] [ text "Wind speed variation" ]
          , intInput
              course.gustGenerator.speedVariation.start
              (UpdateGustGen << updateSpeedVariation << updateRangeStart)
              [ HtmlAttr.min "-10", HtmlAttr.step "1", HtmlAttr.max "0" ]
          , intInput
              course.gustGenerator.speedVariation.end
              (UpdateGustGen << updateSpeedVariation << updateRangeEnd)
              [ HtmlAttr.min "0", HtmlAttr.step "1", HtmlAttr.max "10" ]
          ]
      , div
          [ class "form-group range" ]
          [ label [ class "" ] [ text "Wind origin variation" ]
          , intInput
              course.gustGenerator.originVariation.start
              (UpdateGustGen << updateOriginVariation << updateRangeStart)
              [ HtmlAttr.min "-20", HtmlAttr.step "1", HtmlAttr.max "0" ]
          , intInput
              course.gustGenerator.originVariation.end
              (UpdateGustGen << updateOriginVariation << updateRangeEnd)
              [ HtmlAttr.min "0", HtmlAttr.step "1", HtmlAttr.max "20" ]
          ]
      ]
  , div
      [ class "form-actions btn-group btn-group-justified" ]
      [ a
          [ onClick addr (Save False)
          , class "btn btn-primary btn-save"
          , disabled saving
          ]
          [ text "Save" ]
      , a
          [ onClick addr (Save True)
          , class "btn btn-default btn-save-and-try"
          , disabled saving
          ]
          [ text "Save and try" ]
      ]
  , if track.status == Draft then
      div
        [ class "btn-group-vertical" ]
        [ button
            [ onClick addr ConfirmPublish
            , class "btn btn-default btn-block btn-confirm-publish"
            ]
            [ text "Save and publish" ]
        , if editor.confirmPublish then
            button
              [ onClick addr Publish, class "btn btn-success btn-block btn-confirm-publish" ]
              [ text "Confirm? You can't go back!" ]
          else
            text ""
        ]
    else
      text ""
  ]


surfaceBlock : Editor -> Html
surfaceBlock editor =
  let
    modes =
      [ Watch, CreateTile Water, CreateTile Rock, CreateTile Grass, Erase ]

    currentMode =
      realMode editor
  in
    div
      [ class "surface-modes" ]
      (List.map (renderSurfaceMode currentMode) modes)


renderSurfaceMode : Mode -> Mode -> Html
renderSurfaceMode currentMode mode =
  let
    color =
      case mode of
        CreateTile kind ->
          tileKindColor kind ( 0, 0 )

        Erase ->
          colors.sand

        Watch ->
          "white"

    ( abbr, label ) =
      modeName mode
  in
    a
      [ classList [ ( "current", currentMode == mode ), ( abbr, True ) ]
      , onClick addr (SetMode mode)
      , style [ ( "background-color", color ), ( "border-color", color ) ]
      , title label
      ]
      [ text abbr ]


renderGatesGroups : Course -> List Html
renderGatesGroups { start, gates } =
  [ table
      [ class "" ]
      [ thead
          []
          [ tr
              []
              [ th [] []
              , th [] [ text "Cx" ]
              , th [] [ text "Cy" ]
              , th [] [ text "W" ]
              , th [] [ text "Or." ]
              , th [] []
              ]
          ]
      , tbody
          []
          (tr
            []
            [ th [] [ text "S" ]
            , td [] [ intInput ((round << fst) start.center) SetStartCenterX [ step "10" ] ]
            , td [] [ intInput ((round << snd) start.center) SetStartCenterY [ step "10" ] ]
            , td [] [ intInput (round start.width) SetStartWidth [ step "10" ] ]
            , td [] [ orientationOptions SetStartOrientation start.orientation ]
            , td [] []
            ]
            :: List.indexedMap
                (\i gate ->
                  tr
                    []
                    [ th [] [ text ("G" ++ toString (i + 1)) ]
                    , th [] [ intInput ((round << fst) gate.center) (SetGateCenterX i) [ step "10" ] ]
                    , th [] [ intInput ((round << snd) gate.center) (SetGateCenterY i) [ step "10" ] ]
                    , th [] [ intInput (round gate.width) (SetGateWidth i) [ step "10" ] ]
                    , td [] [ orientationOptions (SetGateOrientation i) gate.orientation ]
                    , td [ onClick formAddr (RemoveGate i) ] [ text "X" ]
                    ]
                )
                gates
          )
      ]
  , button
      [ onClick formAddr AddGate
      , class "btn btn-sm btn-primary btn-block"
      ]
      [ text "Add gate" ]
  ]


orientationOptions : (Orientation -> FormUpdate) -> Orientation -> Html
orientationOptions toMsg current =
  div
    [ class "btn-group btn-group-xs orientations" ]
    (List.map
      (\o ->
        span
          [ onClick formAddr (toMsg o)
          , classList
              [ ( "btn btn-default", True )
              , ( "active", o == current )
              ]
          ]
          [ text (orientationAbbr o) ]
      )
      [ North, South, East, West ]
    )


intInput : number -> (Int -> FormUpdate) -> List Attribute -> Html
intInput val formUpdate attrs =
  textInput
    ([ value (toString val)
     , onIntInput formAddr formUpdate
     , type' "number"
     ]
      ++ attrs
    )


sideBlock : String -> Bool -> Action -> List Html -> Html
sideBlock title open action content =
  div [ classList [ ( "aside-module", True ), ( "closed", not open ) ] ]
    <| [ div
          [ class "module-header" ]
          [ a
              [ class "module-title", onClick addr action ]
              [ text title
              , span
                  [ class
                      <| "glyphicon glyphicon-"
                      ++ if open then
                          "chevron-down"
                         else
                          "chevron-right"
                  ]
                  []
              ]
          ]
       , div [ class "module-body" ] content
       ]
