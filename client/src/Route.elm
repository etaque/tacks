module Route exposing (..)

import RouteParser exposing (..)
import Page.Admin.Route as AdminRoute
import Page.Forum.Route as ForumRoute
import Navigation


parser : Navigation.Location -> Route
parser location =
    fromPath location.pathname


type Route
    = Home
    | Login
    | Register
    | Explore
    | ListDrafts
    | EditTrack String
    | PlayTrack String
    | PlayTimeTrial
    | Forum ForumRoute.Route
    | Admin AdminRoute.Route
    | NotFound
    | EmptyRoute


type RouteJump
    = ForMain
    | ForAdmin AdminRoute.Route AdminRoute.Route
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
    , static Explore "/explore"
    , static ListDrafts "/drafts"
    , dyn1 EditTrack "/edit/" string ""
    , dyn1 PlayTrack "/play/" string ""
    , static PlayTimeTrial "/time-trial"
    ]
        ++ (mapMatchers Admin AdminRoute.matchers)
        ++ (mapMatchers Forum ForumRoute.matchers)


toPath : Route -> String
toPath route =
    case route of
        Home ->
            "/"

        Login ->
            "/login"

        Register ->
            "/register"

        Explore ->
            "/explore"

        ListDrafts ->
            "/drafts"

        EditTrack id ->
            "/edit/" ++ id

        PlayTrack id ->
            "/play/" ++ id

        PlayTimeTrial ->
            "/time-trial"

        Forum forumRoute ->
            ForumRoute.toPath forumRoute

        Admin adminRoute ->
            AdminRoute.toPath adminRoute

        EmptyRoute ->
            "/"

        NotFound ->
            "/404"


detectJump : Route -> Route -> RouteJump
detectJump prevRoute route =
    case ( prevRoute, route ) of
        ( Admin from, Admin to ) ->
            ForAdmin from to

        _ ->
            if prevRoute /= route then
                ForMain
            else
                None
