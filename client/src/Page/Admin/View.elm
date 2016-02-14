module Page.Admin.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import TransitStyle exposing (fadeSlideLeft)

import Model.Shared exposing (Track, Context)
import Route

import Page.Admin.Route exposing (..)
import Page.Admin.Model exposing (..)
import Page.Admin.Update exposing (addr)

import View.Utils exposing (container, linkTo)
import View.Layout as Layout


type Tab = DashboardTab | TracksTab | UsersTab

view : Context -> Route -> Model -> Html
view ctx route model =
  let
    menuItem = routeMenuItem route
  in
    Layout.layoutWithNav "admin" ctx
      [ container "" <|
        [ h1 [] [ text "Admin" ]
        , menu menuItem
        , content route ctx menuItem model
        ]
      ]

menu : Tab -> Html
menu item =
  ul [ class "nav nav-tabs admin-tabs" ]
  [ li [ classList [ ("active", item == DashboardTab) ] ]
    [ linkTo (Route.Admin Dashboard) [ ] [ text "Dashboard" ] ]
  , li [ classList [ ("active", item == TracksTab) ] ]
    [ linkTo (Route.Admin (ListTracks Nothing)) [ ] [ text "Tracks" ] ]
  , li [ classList [ ("active", item == UsersTab) ] ]
    [ linkTo (Route.Admin (ListUsers Nothing)) [ ] [ text "Users" ] ]
  ]

routeMenuItem : Route -> Tab
routeMenuItem r =
  case r of
    Dashboard -> DashboardTab
    ListTracks _ -> TracksTab
    ListUsers _ -> UsersTab

content : Route -> Context -> Tab -> Model -> Html
content route ctx item ({tracks, users} as model) =
  let
    transitStyle =
      case ctx.routeTransition of
        Route.ForAdmin _ _  -> (fadeSlideLeft 40 ctx.transition)
        _ -> []
    tabContent =
      case item of
        DashboardTab ->
          dashboardContent route model
        TracksTab ->
          tracksContent route model
        UsersTab ->
          usersContent route model
  in
    div [ class "admin-content", style transitStyle ] tabContent


dashboardContent : Route -> Model -> List Html
dashboardContent route ({tracks, users} as model) =
  [ div [ class "" ] [ text <| toString (List.length users) ++ " users" ]
  , div [ class "" ] [ text <| toString (List.length tracks) ++ " tracks" ]
  ]

tracksContent : Route -> Model -> List Html
tracksContent route ({tracks, users} as model) =
  [ ul [ class "list-unstyled admin-tracks" ]
    (List.map (\t -> trackItem (route == ListTracks (Just t.id)) t) tracks)
  ]

trackItem : Bool -> Track -> Html
trackItem open track =
  li [ ]
  [ div [ class "excerpt" ]
    [ linkTo (Route.EditTrack track.id) [ class "name" ] [ text track.name ]
    , span [ class "label label-default" ] [ text <| toString track.status ]
    , button [ class "btn btn-danger btn-xs pull-right", onClick addr (DeleteTrack track.id) ]
      [ text "Delete" ]
    ]
  , div [ classList [ ("detail", True), ("open", open) ] ]
    [ text "detail" ]
  ]

usersContent : Route -> Model -> List Html
usersContent route ({tracks, users} as model) =
  [ ul [ class "list-unstyled admin-users" ]
    (List.map (\u -> userItem (route == ListUsers (Just u.id)) u) users)
  ]

userItem : Bool -> User -> Html
userItem open user =
  li [ ]
  [ div [ class "excerpt" ]
    [ linkTo (Route.Admin (ListUsers (Just user.id))) [ class "name" ] [ text user.handle ]
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
