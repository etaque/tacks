module Routes (..) where

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
  | NotFound
  | EmptyRoute

type RouteTransition
  = ForMain
  | ForAdmin AdminRoutes.Route AdminRoutes.Route
  | None


fromPath : String -> Route
fromPath path =
  match matchers path
    |> Maybe.withDefault NotFound


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
    EmptyRoute -> "/"
    NotFound -> "/404"

detectTransition : Route -> Route -> RouteTransition
detectTransition prevRoute route =
  case (prevRoute, route) of
    (Admin from, Admin to) ->
      ForAdmin from to
    _ ->
      if prevRoute /= route then
        ForMain
      else
        None
