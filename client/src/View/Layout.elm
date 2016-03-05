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
      [ class "new-layout" ]
      [ Html.Lazy.lazy HexBg.render ctx.dims
      , div
          [ class "fixed" ]
          [ header ctx.player
          , div [ class ("content " ++ name) ] content
          , footer ctx.player
          ]
      ]


header : Player -> Html
header player =
  div
    [ class "container header" ]
    <| logo
    :: if player.guest then
        guestMenu
       else
        userMenu player


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
      [ li [] [ Utils.linkTo Route.Login [] [ text "Login" ] ]
      , li [] [ Utils.linkTo Route.Register [] [ text "Register" ] ]
      ]
  ]


userMenu : Player -> List Html
userMenu player =
  [ ul
      [ class "user-menu"
      ]
      [ li
          [ class "info" ]
          [ text (Utils.playerHandle player) ]
      , li
          []
          [ a [ onClick appActionsAddress Logout ] [ text "Logout" ] ]
      ]
  ]


footer : Player -> Html
footer player =
  div
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


layoutWithSidebar : String -> List Html -> List Html -> Html
layoutWithSidebar name sideContent mainContent =
  div
    [ class ("layout " ++ name) ]
    [ aside
        [ style [ ( "width", toString Constants.sidebarWidth ++ "px" ) ] ]
        sideContent
    , main' [] mainContent
    ]
