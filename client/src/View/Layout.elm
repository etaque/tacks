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
import TransitStyle
import Page.Admin.Model as Admin
import Page.Forum.Model as Forum
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
  let
    tiledBackground =
      Html.Lazy.lazy HexBg.render ( fst ctx.dims - Constants.sidebarWidth, Constants.headerHeight )
  in
    Html.header
      attrs
      [ tiledBackground
      , div
          [ class "container" ]
          content
      ]


footer : Player -> Html
footer player =
  Html.footer
    []
    [ div
        [ class "container footer" ]
        (if isAdmin player then
          [ ul
              []
              [ li [] [ Utils.linkTo Route.ListDrafts [] [ text "Track editor" ] ]
              , li [] [ Utils.linkTo (Route.Forum Forum.initialRoute) [] [ text "Forum" ] ]
              , li [] [ Utils.linkTo (Route.Admin Admin.initialRoute) [] [ text "Admin" ] ]
              ]
          ]
         else
          []
        )
    ]


type Nav
  = Home
  | Explore
  | Build
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
      [ class "layout-fullscreen layout-site"
      , id name
      ]
      [ aside
          [ class "dark" ]
          (logo :: (sideMenu ctx.player maybeCurrentNav))
      , main'
          []
          [ div
              [ class "scrollable", style transitStyle ]
              mainContent
          ]
      ]


layoutWithSidebar : String -> Context -> List Html -> List Html -> List Html -> Html
layoutWithSidebar name ctx navContent sideContent mainContent =
  div
    [ class "layout-fullscreen"
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
      , sideMenuItem Route.Home "explore" "Explore tracks" (maybeCurrent == Just Explore)
      , sideMenuItem Route.ListDrafts "palette" "Build tracks" (maybeCurrent == Just Build)
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
