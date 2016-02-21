module View.Layout where

import Html exposing (..)
import Html.Attributes exposing (..)

import View.Sidebar as Sidebar
import Constants
import Model.Shared exposing (Context)
import Route

import TransitStyle


layoutWithNav : String -> Context -> List Html -> Html
layoutWithNav name ctx content =
  let
    transitStyle =
      case ctx.routeTransition of
        Route.ForMain -> (TransitStyle.fade ctx.transition)
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
        [ style [ ("width", toString Constants.sidebarWidth ++ "px") ] ]
        sideContent
    , main' [ ] mainContent
    ]

