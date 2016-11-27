module Page.Forum.Route exposing (Route(..), matchers, toPath)

import RouteParser exposing (..)


type Route
    = Index
    | ShowTopic String
    | NewTopic


matchers : List (Matcher Route)
matchers =
    [ static Index "/forum"
    , dyn1 ShowTopic "/forum/topic/" string ""
    , static NewTopic "/forum/new"
    ]


toPath : Route -> String
toPath route =
    "/forum"
        ++ case route of
            Index ->
                ""

            ShowTopic id ->
                "/topic/" ++ id

            NewTopic ->
                "/new"
