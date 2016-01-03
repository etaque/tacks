module Screens.Layout where

import Html exposing (..)
import Html.Attributes exposing (..)

import Screens.Sidebar as Sidebar
import Constants exposing (..)
import AppTypes exposing (..)
import Routes

import TransitStyle exposing (fadeSlideLeft)


layoutWithNav : String -> Context -> List Html -> Html
layoutWithNav name ctx content =
  let
    transitStyle =
      case ctx.routeTransition of
        Routes.ForMain -> (fadeSlideLeft 40 ctx.transition)
        _ -> []
  in
    layout name
      (Sidebar.view ctx)
      [ div
          [ class "padded"
          , style transitStyle
          ]
        content
      ]


layout : String -> List Html -> List Html -> Html
layout name sideContent mainContent =
  div
    [ class ("layout " ++ name) ]
    [ aside
        [ style [ ("width", toString sidebarWidth ++ "px") ] ]
        sideContent
    , main' [ ] mainContent
    ]

