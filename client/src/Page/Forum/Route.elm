module Page.Forum.Route (Route(..), matchers, toPath) where

import RouteParser exposing (..)


type Route
  = Index
  | Topic String


-- router : Router Route
-- router =
--   RouteParser.router matchers toPath


matchers : List (Matcher Route)
matchers =
  [ static Index "/forum"
  , dyn1 Topic "/forum/" string ""
  ]


toPath : Route -> String
toPath route =
  "/forum" ++ case route of
    Index -> ""
    Topic id -> "/forum/" ++ id

