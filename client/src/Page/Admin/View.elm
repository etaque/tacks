module Page.Admin.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import TransitStyle
import Model.Shared exposing (Track, Context, RaceReport)
import Route
import Page.Admin.Route exposing (..)
import Page.Admin.Model exposing (..)
import View.Utils as Utils exposing (container, linkTo)
import View.Layout as Layout
import View.Race as Race


type Tab
  = DashboardTab
  | TracksTab
  | UsersTab
  | ReportsTab


view : Context -> Route -> Model -> Layout.Site Msg
view ctx route model =
  let
    menuItem =
      routeMenuItem route
  in
    Layout.Site
      "admin"
      (Just Layout.Admin)
      [ Layout.header
          ctx
          [ class "with-tabs" ]
          [ h1 [] [ text "Admin" ]
          , menu menuItem
          ]
      , Layout.section
          [ class "white inside" ]
          [ content route ctx menuItem model
          ]
      ]


menu : Tab -> Html Msg
menu item =
  div
    [ class "tabs-container admin-tabs" ]
    [ div
        [ class "tabs-content" ]
        [ linkTo
            (Route.Admin Dashboard)
            [ classList [ ( "tab", True ), ( "active", item == DashboardTab ) ] ]
            [ text "Dashboard" ]
        , linkTo
            (Route.Admin ListReports)
            [ classList [ ( "tab", True ), ( "active", item == ReportsTab ) ] ]
            [ text "Reports" ]
        , linkTo
            (Route.Admin (ListUsers Nothing))
            [ classList [ ( "tab", True ), ( "active", item == UsersTab ) ] ]
            [ text "Users" ]
        , linkTo
            (Route.Admin (ListTracks Nothing))
            [ classList [ ( "tab", True ), ( "active", item == TracksTab ) ] ]
            [ text "Tracks" ]
        ]
    ]


routeMenuItem : Route -> Tab
routeMenuItem r =
  case r of
    Dashboard ->
      DashboardTab

    ListUsers _ ->
      UsersTab

    ListReports ->
      ReportsTab

    ListTracks _ ->
      TracksTab


content : Route -> Context -> Tab -> Model -> Html Msg
content route ctx item ({ tracks, users } as model) =
  let
    transitStyle =
      case ctx.routeJump of
        Route.ForAdmin _ _ ->
          (TransitStyle.fade ctx.transition)

        _ ->
          []

    tabContent =
      case item of
        DashboardTab ->
          dashboardContent route model

        TracksTab ->
          tracksContent route model

        UsersTab ->
          usersContent route model

        ReportsTab ->
          reportsContent model
  in
    div [ class "admin-content", style transitStyle ] tabContent


dashboardContent : Route -> Model -> List (Html Msg)
dashboardContent route ({ tracks, users } as model) =
  [ div [ class "" ] [ text <| toString (List.length users) ++ " users" ]
  , div [ class "" ] [ text <| toString (List.length tracks) ++ " tracks" ]
  ]


tracksContent : Route -> Model -> List (Html Msg)
tracksContent route ({ tracks, users } as model) =
  [ table
      [ class "admin-table admin-tracks" ]
      (List.map trackItem tracks)
  ]


trackItem : Track -> Html Msg
trackItem track =
  tr
    []
    [ th
        []
        [ linkTo (Route.EditTrack track.id) [ class "name" ] [ text track.name ]
        ]
    , td [] [ text (toString track.status) ]
    , td [] [ text (Utils.formatDate track.creationTime) ]
    ]


usersContent : Route -> Model -> List (Html Msg)
usersContent route ({ tracks, users } as model) =
  [ table
      [ class "admin-table admin-users" ]
      (List.map userItem users)
  ]


userItem : User -> Html Msg
userItem user =
  tr
    []
    [ th
        []
        [ linkTo (Route.Admin (ListUsers (Just user.id))) [ class "name" ] [ text user.handle ]
        ]
    , td [] [ text user.email ]
    , td [] [ text (Utils.formatDate user.creationTime) ]
    ]


reportsContent : Model -> List (Html Msg)
reportsContent model =
  [ Race.reports True (\_ -> onClick NoOp) model.reports
  ]
