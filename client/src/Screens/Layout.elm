module Screens.Layout where

import Html exposing (..)
import Html.Attributes exposing (..)

import Screens.Sidebar as Sidebar
import Constants exposing (..)
import AppTypes exposing (..)

import Transition


layoutWithNav : String -> Context -> List Html -> Html
layoutWithNav name ctx content =
  layout name
    (Sidebar.view ctx)
    [ div
        [ class "padded"
        , style (transitionStyle ctx.transition)
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

transitionStyle : Transition.Transition -> List (String, String)
transitionStyle t =
  case Transition.value t of
    Just v ->
      [ ("opacity", toString v)
      , ("transform", "translateX(" ++ toString (40 - v * 40) ++ "px)")
      ]
    Nothing ->
      []
