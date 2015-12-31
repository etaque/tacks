module Screens.Admin.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Routes

import Screens.Admin.Routes exposing (..)
import Screens.Admin.Types exposing (..)
import Screens.Admin.Updates exposing (addr)

import Screens.Utils exposing (..)
import Screens.Layout as Layout

import Transit.Style


type Tab = DashboardTab | TracksTab | UsersTab

view : Context -> Screen -> Html
view ctx screen =
  let
    menuItem = routeMenuItem screen.route
  in
    Layout.layoutWithNav "admin" ctx
      [ container "" <|
        [ h1 [] [ text "Admin" ]
        , menu menuItem
        , content ctx menuItem screen
        ]
      ]

menu : Tab -> Html
menu item =
  ul [ class "nav nav-tabs admin-tabs" ]
  [ li [ classList [ ("active", item == DashboardTab) ] ]
    [ linkTo (Routes.Admin Dashboard) [ ] [ text "Dashboard" ] ]
  , li [ classList [ ("active", item == TracksTab) ] ]
    [ linkTo (Routes.Admin (ListTracks Nothing)) [ ] [ text "Tracks" ] ]
  , li [ classList [ ("active", item == UsersTab) ] ]
    [ linkTo (Routes.Admin (ListUsers Nothing)) [ ] [ text "Users" ] ]
  ]

routeMenuItem : Route -> Tab
routeMenuItem r =
  case r of
    Dashboard -> DashboardTab
    ListTracks _ -> TracksTab
    ListUsers _ -> UsersTab

content : Context -> Tab -> Screen -> Html
content ctx item ({tracks, users} as screen) =
  let
    transitStyle = Transit.Style.fadeSlideLeft 50 screen
    tabContent =
      case item of
        DashboardTab ->
          dashboardContent screen
        TracksTab ->
          tracksContent screen
        UsersTab ->
          usersContent screen
  in
    div [ class "admin-content", style transitStyle ] tabContent


dashboardContent : Screen -> List Html
dashboardContent ({tracks, users} as screen) =
  [ div [ class "" ] [ text <| toString (List.length users) ++ " users" ]
  , div [ class "" ] [ text <| toString (List.length tracks) ++ " tracks" ]
  ]

tracksContent : Screen -> List Html
tracksContent ({tracks, users, route} as screen) =
  [ ul [ class "list-unstyled admin-tracks" ]
    (List.map (\t -> trackItem (route == ListTracks (Just t.id)) t) tracks)
  ]

trackItem : Bool -> Track -> Html
trackItem open track =
  li [ ]
  [ div [ class "excerpt" ]
    [ linkTo (Routes.EditTrack track.id) [ class "name" ] [ text track.name ]
    , span [ class "label label-default" ] [ text <| toString track.status ]
    , button [ class "btn btn-danger btn-xs pull-right", onClick addr (DeleteTrack track.id) ]
      [ text "Delete" ]
    ]
  , div [ classList [ ("detail", True), ("open", open) ] ]
    [ text "detail" ]
  ]

usersContent : Screen -> List Html
usersContent ({tracks, users, route} as screen) =
  [ ul [ class "list-unstyled admin-users" ]
    (List.map (\u -> userItem (route == ListUsers (Just u.id)) u) users)
  ]

userItem : Bool -> User -> Html
userItem open user =
  li [ ]
  [ div [ class "excerpt" ]
    [ linkTo (Routes.Admin (ListUsers (Just user.id))) [ class "name" ] [ text user.handle ]
    , span [ class "email" ] [ text user.email ]
    ]
  , div [ classList [ ("detail", True), ("open", open) ] ]
    [ dl'
      [ ("Email", user.email)
      , ("VMG Magnet", toString user.vmgMagnet)
      ]
    ]
  ]

dl' : List (String, String) -> Html
dl' items =
  dl [ class "dl-horizontal" ] (List.concatMap (\(term, desc) -> [ dt [] [ text term ], dd [] [ text desc ] ]) items)
