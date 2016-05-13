module View.Layout (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy
import Markdown
import View.HexBg as HexBg
import View.Logo as Logo
import View.Utils as Utils
import Model exposing (appActionsAddress, Action(Logout))
import Model.Shared exposing (Context, Player, isAdmin)
import Route
import Page.Forum.Route as Forum
import TransitStyle
import Constants


logo : Html
logo =
  Utils.linkTo
    Route.Home
    [ class "logo" ]
    [ Logo.render
    , span [] [ text "Tacks" ]
    ]


section : List Attribute -> List Html -> Html
section attrs content =
  Html.section
    attrs
    [ div [ class "container" ] content
    ]


header : Context -> List Attribute -> List Html -> Html
header ctx attrs content =
  Html.header
    attrs
    [ div
        [ class "container" ]
        content
    ]


type Nav
  = Home
  | Explore
  | Build
  | Discuss
  | Login
  | Register


siteLayout : String -> Context -> Maybe Nav -> List Html -> Html
siteLayout name ctx maybeCurrentNav mainContent =
  let
    transitStyle =
      case ctx.routeTransition of
        Route.ForMain ->
          (TransitStyle.fade ctx.transition)

        _ ->
          []

    tiledBackground =
      Html.Lazy.lazy HexBg.render ( fst ctx.dims - Constants.sidebarWidth, snd ctx.dims )
  in
    div
      [ class "layout-game layout-site"
      , id name
      ]
      [ aside
          [ class "dark" ]
          (logo :: (sideMenu ctx.player maybeCurrentNav))
      , main'
          []
          [ div
              [ class "scrollable" ]
              [ tiledBackground
              , div
                  [ class "content"
                  , style transitStyle
                  ]
                  mainContent
              ]
          ]
      ]


gameLayout : String -> Context -> List Html -> List Html -> List Html -> Html
gameLayout name ctx navContent sideContent mainContent =
  div
    [ class "layout-game"
    , id name
    ]
    [ aside
        []
        (logo :: sideContent)
    , subHeader
        ctx.player
        navContent
    , main' [] mainContent
    ]


subHeader : Player -> List Html -> Html
subHeader player content =
  nav
    [ class "toolbar" ]
    content


sideMenu : Player -> Maybe Nav -> List Html
sideMenu player maybeCurrent =
  [ if player.guest then
      div
        [ class "guest" ]
        [ div
            [ class "player" ]
            [ text "Guest session" ]
        , div
            [ class "menu" ]
            [ sideMenuItem Route.Login "face" "Login" (maybeCurrent == Just Login)
            , sideMenuItem Route.Register "person_add" "Register" (maybeCurrent == Just Register)
            ]
        , hr [] []
        ]
    else
      div
        [ class "player" ]
        [ img [ src (Utils.avatarUrl 42 player), class "avatar" ] []
        , span [ class "handle" ] [ text (Utils.playerHandle player) ]
        , a
            [ class "logout"
            , title "Logout"
            , onClick appActionsAddress Logout
            ]
            [ Utils.mIcon "exit_to_app" [] ]
        ]
  , div
      [ class "menu" ]
      [ sideMenuItem Route.Home "home" "Home" (maybeCurrent == Just Home)
      , sideMenuItem Route.Explore "explore" "Explore" (maybeCurrent == Just Explore)
      , if player.guest then
          text ""
        else
          sideMenuItem Route.ListDrafts "palette" "Build" (maybeCurrent == Just Build)
      , if player.guest then
          text ""
        else
          sideMenuItem (Route.Forum Forum.Index) "face" "Discuss" (maybeCurrent == Just Discuss)
      ]
  , hr [] []
  , div
      [ class "made-by" ]
      [ Markdown.toHtml """
An [open source](http://github.com/etaque/tacks) game crafted with love
by [@etaque](http://twitter.com/etaque).

Written with [elm-lang](http://elm-lang.org).
        """
      ]
  ]


sideMenuItem : Route.Route -> String -> String -> Bool -> Html
sideMenuItem route icon label current =
  div
    [ classList
        [ ( "menu-item", True )
        , ( "current", current )
        ]
    ]
    [ Utils.linkTo
        route
        []
        [ Utils.mIcon icon []
        , text label
        ]
    ]
