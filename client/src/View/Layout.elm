module View.Layout (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy
import View.Sidebar as Sidebar
import View.HexBg as HexBg
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
      [ class "new-layout"
      , id name
      ]
      [ Html.Lazy.lazy HexBg.render ctx.dims
      , div
          [ class "fixed"
          ]
          [ header ctx.player
          , div [ class "content" ] content
          , footer ctx.player
          ]
      ]


header : Player -> Html
header player =
  let
    menu =
      if player.guest then
        guestMenu
      else
        userMenu player
  in
    nav
      [ class "header" ]
      [ div [ class "container" ] (logo :: menu) ]


logo : Html
logo =
  div
    [ class "logo" ]
    [ Utils.linkTo
        Route.Home
        []
        [ img [ src "/assets/images/logo-header-2@2x.png" ] [] ]
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


layoutWithSidebar : String -> List Html -> List Html -> Html
layoutWithSidebar name sideContent mainContent =
  div
    [ class ("layout " ++ name) ]
    [ aside
        [ style [ ( "width", toString Constants.sidebarWidth ++ "px" ) ] ]
        sideContent
    , main' [] mainContent
    ]
