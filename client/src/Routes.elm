module Routes (Route(..), fromPath, toPath) where

import RouteParser exposing (..)
import Screens.Admin.Routes as AdminRoutes


type Route
  = Home
  | Login
  | Register
  | ShowProfile
  | ShowTrack String
  | ListDrafts
  | EditTrack String
  | PlayTrack String
  | Admin AdminRoutes.Route


fromPath : String -> Maybe Route
fromPath =
  match matchers

matchers : List (Matcher Route)
matchers =
  [ static Home "/"
  , static Login "/login"
  , static Register "/register"
  , static ShowProfile "/me"
  , static ListDrafts "/drafts"
  , dyn1 ShowTrack "/track/" string ""
  , dyn1 EditTrack "/edit/" string ""
  , dyn1 PlayTrack "/play/" string ""
  ] ++ (mapMatchers Admin AdminRoutes.matchers)

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
    Admin adminRoute -> AdminRoutes.toPath adminRoute

