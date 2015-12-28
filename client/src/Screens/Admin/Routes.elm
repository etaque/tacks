module Screens.Admin.Routes (Route(..), matchers, toPath) where

import RouteParser exposing (..)


type Route
  = Dashboard
  | ListTracks (Maybe String)
  | ListUsers (Maybe String)


router : Router Route
router =
  RouteParser.router matchers toPath

matchers : List (Matcher Route)
matchers =
  [ static Dashboard "/admin"
  , static (ListTracks Nothing) "/admin/tracks"
  , dyn1 (ListTracks << Just) "/admin/tracks/" string ""
  , static (ListUsers Nothing) "/admin/users"
  , dyn1 (ListUsers << Just) "/admin/users/" string ""
  ]

toPath : Route -> String
toPath route =
  "/admin" ++ case route of
    Dashboard -> ""
    ListTracks id -> "/tracks" ++ (maybe id)
    ListUsers id -> "/users" ++ (maybe id)

maybe : Maybe String -> String
maybe ms =
  case ms of
    Just s -> "/" ++ s
    Nothing -> ""

