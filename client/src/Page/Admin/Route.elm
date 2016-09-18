module Page.Admin.Route exposing (Route(..), matchers, toPath)

import RouteParser exposing (..)


type Route
    = Dashboard
    | ListTracks (Maybe String)
    | ListUsers (Maybe String)
    | ListReports


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
    , static ListReports "/admin/reports"
    ]


toPath : Route -> String
toPath route =
    "/admin"
        ++ case route of
            Dashboard ->
                ""

            ListTracks id ->
                "/tracks" ++ (maybe id)

            ListUsers id ->
                "/users" ++ (maybe id)

            ListReports ->
                "/reports"


maybe : Maybe String -> String
maybe ms =
    case ms of
        Just s ->
            "/" ++ s

        Nothing ->
            ""
