module Page.Admin.Route exposing (Route(..), matchers, toPath)

import RouteParser exposing (..)


type Route
    = Dashboard
    | ListUsers (Maybe String)
    | ListTimeTrials
    | ListTracks (Maybe String)
    | ListReports


router : Router Route
router =
    RouteParser.router matchers toPath


matchers : List (Matcher Route)
matchers =
    [ static Dashboard "/admin"
    , static (ListUsers Nothing) "/admin/users"
    , dyn1 (ListUsers << Just) "/admin/users/" string ""
    , static ListTimeTrials "/admin/time-trials"
    , static (ListTracks Nothing) "/admin/tracks"
    , dyn1 (ListTracks << Just) "/admin/tracks/" string ""
    , static ListReports "/admin/reports"
    ]


toPath : Route -> String
toPath route =
    "/admin"
        ++ case route of
            Dashboard ->
                ""

            ListUsers id ->
                "/users" ++ (maybe id)

            ListTimeTrials ->
                "/time-trials"

            ListTracks id ->
                "/tracks" ++ (maybe id)

            ListReports ->
                "/reports"


maybe : Maybe String -> String
maybe ms =
    case ms of
        Just s ->
            "/" ++ s

        Nothing ->
            ""
