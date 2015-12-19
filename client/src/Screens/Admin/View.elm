module Screens.Admin.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Routes exposing (..)

import Screens.Admin.Types exposing (..)
import Screens.Admin.Updates exposing (addr)

import Screens.Utils exposing (..)
import Screens.Layout as Layout


type Tab = DashboardTab | TracksTab | UsersTab

view : Context -> AdminRoute -> Screen -> Html
view ctx route screen =
  let
    menuItem = routeMenuItem route
  in
    Layout.layoutWithNav "admin" ctx
      [ container "" <|
        [ h1 [] [ text "Admin" ]
        , menu menuItem
        ] ++ content route menuItem screen
      ]

menu : Tab -> Html
menu item =
  ul [ class "nav nav-tabs admin-tabs" ]
  [ li [ classList [ ("active", item == DashboardTab) ] ]
    [ linkTo (Admin Dashboard) [ ] [ text "Dashboard" ] ]
  , li [ classList [ ("active", item == TracksTab) ] ]
    [ linkTo (Admin (ListTracks Nothing)) [ ] [ text "Tracks" ] ]
  , li [ classList [ ("active", item == UsersTab) ] ]
    [ linkTo (Admin (ListUsers Nothing)) [ ] [ text "Users" ] ]
  ]

routeMenuItem : AdminRoute -> Tab
routeMenuItem r =
  case r of
    Dashboard -> DashboardTab
    ListTracks _ -> TracksTab
    ListUsers _ -> UsersTab

content : AdminRoute -> Tab -> Screen -> List Html
content route item ({tracks, users} as screen) =
  case item of
    DashboardTab ->
      dashboardContent screen
    TracksTab ->
      tracksContent route screen
    UsersTab ->
      usersContent route screen

dashboardContent : Screen -> List Html
dashboardContent ({tracks, users} as screen) =
  [ div [ class "" ] [ text <| toString (List.length users) ++ " users" ]
  , div [ class "" ] [ text <| toString (List.length tracks) ++ " tracks" ]
  ]

tracksContent : AdminRoute -> Screen -> List Html
tracksContent route ({tracks, users} as screen) =
  [ ul [ class "list-unstyled admin-tracks" ]
    (List.map (\t -> trackItem (route == ListTracks (Just t.id)) t) tracks)
  ]

trackItem : Bool -> Track -> Html
trackItem open track =
  li [ ]
  [ div [ class "excerpt" ]
    [ linkTo (EditTrack track.id) [ class "name" ] [ text track.name ]
    , span [ class "label label-default" ] [ text <| toString track.status ]
    , button [ class "btn btn-danger btn-xs pull-right", onClick addr (DeleteTrack track.id) ]
      [ text "Delete" ]
    ]
  , div [ classList [ ("detail", True), ("open", open) ] ]
    [ text "detail" ]
  ]

usersContent : AdminRoute -> Screen -> List Html
usersContent route ({tracks, users} as screen) =
  [ ul [ class "list-unstyled admin-users" ]
    (List.map (\u -> userItem (route == ListUsers (Just u.id)) u) users)
  ]

userItem : Bool -> User -> Html
userItem open user =
  li [ ]
  [ div [ class "excerpt" ]
    [ linkTo (Admin (ListUsers (Just user.id))) [ class "name" ] [ text user.handle ]
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
