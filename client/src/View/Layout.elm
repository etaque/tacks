module View.Layout (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy
import View.HexBg as HexBg
import View.Logo as Logo
import View.Utils as Utils
import Constants
import Model exposing (appActionsAddress, Action(Logout))
import Model.Shared exposing (Context, Player, isAdmin)
import Route
import TransitStyle
import Page.Admin.Model as Admin
import Page.Forum.Model as Forum


layoutWithNav : String -> Context -> List Html -> Html
layoutWithNav name ctx content =
  let
    transitStyle =
      case ctx.routeTransition of
        Route.ForMain ->
          (TransitStyle.fade ctx.transition)

        _ ->
          []
  in
    div
      [ class "layout-vertical"
      , id name
      ]
      [ Html.Lazy.lazy HexBg.render ctx.dims
      , header ctx.player []
      , div
          [ class "fixed"
          ]
          [ div [ class "content" ] content
          , footer ctx.player
          ]
      ]


header : Player -> List Html -> Html
header player navContent =
  let
    menu =
      if player.guest then
        guestMenu
      else
        userMenu player

    navBlock =
      div [ class "page-nav" ] navContent
  in
    nav
      [ class "header" ]
      [ div [ class "container" ] (logo :: navBlock :: menu) ]


logo : Html
logo =
  Utils.linkTo
    Route.Home
    [ class "logo" ]
    [ Logo.render
    , span [] [ text "Tacks" ]
    ]


guestMenu : List Html
guestMenu =
  [ ul
      [ class "user-menu" ]
      [ li [] [ Utils.linkTo Route.Login [] [ text "login" ] ]
      , li [] [ Utils.linkTo Route.Register [] [ text "register" ] ]
      ]
  ]


userMenu : Player -> List Html
userMenu player =
  [ ul
      [ class "user-menu"
      ]
      [ li
          [ class "info" ]
          [ text <| "[" ++ (Utils.playerHandle player) ++ "]" ]
      , li
          []
          [ a [ onClick appActionsAddress Logout ] [ text "logout" ] ]
      ]
  ]


section : String -> List Html -> Html
section class' content =
  Html.section [ class class' ] [ div [ class "container" ] content ]


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


layoutWithSidebar : String -> Context -> List Html -> List Html -> List Html -> Html
layoutWithSidebar name ctx navContent sideContent mainContent =
  div
    [ class "layout-fullscreen"
    , id name
    ]
    [ aside
        [ style [ ( "width", toString Constants.sidebarWidth ++ "px" ) ] ]
        (logo :: sideContent)
    , if List.isEmpty navContent then
        text ""
      else
        subHeader
          ctx.player
          navContent
    , main' [] mainContent
    ]


subHeader : Player -> List Html -> Html
subHeader player content =
  nav
    [ class "toolbar" ]
    content
