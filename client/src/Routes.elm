module Routes where

import RouteParser exposing (..)


type Route
  = Home
  | Login
  | Register
  | ShowProfile
  | ShowTrack String
  | ListDrafts
  | EditTrack String
  | PlayTrack String
  | Admin AdminRoute

type AdminRoute
  = Dashboard
  | ListTracks (Maybe String)
  | ListUsers (Maybe String)

routeParsers : Parsers Route
routeParsers =
  [ static Home "/"
  , static Login "/login"
  , static Register "/register"
  , static ShowProfile "/me"
  , static ListDrafts "/drafts"
  , dyn1 ShowTrack "/track/" string ""
  , dyn1 EditTrack "/edit/" string ""
  , dyn1 PlayTrack "/play/" string ""
  , static (Admin Dashboard) "/admin"
  , static (Admin (ListTracks Nothing)) "/admin/tracks"
  , dyn1 (Admin << ListTracks << Just) "/admin/tracks/" string ""
  , static (Admin (ListUsers Nothing)) "/admin/users"
  , dyn1 (Admin << ListUsers << Just) "/admin/users/" string ""
  ]


toPath : Route -> String
toPath route =
  case route of
    Home -> "/"
    Login -> "/login"
    Register -> "/register"
    ShowProfile -> "/me"
    ListDrafts -> "/drafts"
    ShowTrack id -> "/track/" ++ id
    EditTrack id -> "/edit/" ++ id
    PlayTrack id -> "/play/" ++ id
    Admin adminRoute -> "/admin" ++
      case adminRoute of
        Dashboard -> ""
        ListTracks id -> "/tracks" ++ (maybeSegment id)
        ListUsers id -> "/users" ++ (maybeSegment id)

maybeSegment : Maybe String -> String
maybeSegment ms =
  case ms of
    Just s -> "/" ++ s
    Nothing -> ""
