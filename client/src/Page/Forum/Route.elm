module Page.Forum.Route (Route(..), matchers, toPath) where

import RouteParser exposing (..)


type Route
  = Index
  | ShowTopic String
  | NewTopic


matchers : List (Matcher Route)
matchers =
  [ static Index "/forum"
  , dyn1 ShowTopic "/forum/t/" string ""
  , static NewTopic "/forum/new"
  ]


toPath : Route -> String
toPath route =
  "/forum" ++ case route of
    Index -> ""
    ShowTopic id -> "/t/" ++ id
    NewTopic -> "/new"

