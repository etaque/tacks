module Page.Forum.Route (Route(..), matchers, toPath) where

import RouteParser exposing (..)


type Route
  = Index
  | ShowTopic String


matchers : List (Matcher Route)
matchers =
  [ static Index "/forum"
  , dyn1 ShowTopic "/forum/t/" string ""
  ]


toPath : Route -> String
toPath route =
  "/forum" ++ case route of
    Index -> ""
    ShowTopic id -> "/t/" ++ id

