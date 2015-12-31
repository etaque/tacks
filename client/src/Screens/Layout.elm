module Screens.Layout where

import Html exposing (..)
import Html.Attributes exposing (..)

import Screens.Sidebar as Sidebar
import Constants exposing (..)
import AppTypes exposing (..)

import Transit.Style exposing (fadeSlideLeft)


layoutWithNav : String -> Context -> List Html -> Html
layoutWithNav name ctx content =
  layout name
    (Sidebar.view ctx)
    [ div
        [ class "padded"
        , style (fadeSlideLeft 40 ctx)
        ]
      content
    ]

-- transitionStyle : Context -> List (String, String)
-- transitionStyle {transition} =
--   (Transit.Style.slideLeftEnter transition) ++ (Transit.Style.fadeOutExit transition)

layout : String -> List Html -> List Html -> Html
layout name sideContent mainContent =
  div
    [ class ("layout " ++ name) ]
    [ aside
        [ style [ ("width", toString sidebarWidth ++ "px") ] ]
        sideContent
    , main' [ ] mainContent
    ]

