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

