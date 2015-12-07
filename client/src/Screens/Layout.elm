module Screens.Layout where

import Html exposing (..)
import Html.Attributes exposing (..)

import Screens.Sidebar as Sidebar
import Constants exposing (..)
import AppTypes exposing (..)


layoutWithNav : Context -> List Html -> Html
layoutWithNav ctx content =
  layout
    (Sidebar.view ctx)
    [ div [ class <| "padded " ++ (transitionName ctx.transitStatus) ] content ]

transitionName : TransitStatus -> String
transitionName status =
  case status of
    Exit -> "exit"
    Enter -> "enter"

layout : List Html -> List Html -> Html
layout sideContent mainContent =
  div
    [ class "layout" ]
    [ aside
        [ style [ ("width", toString sidebarWidth ++ "px") ] ]
        sideContent
    , main' [ ] mainContent
    ]

