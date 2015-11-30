module Routes where

import RouteParser exposing (..)


type Route
  = Home
  | Login
  | Register
  | ShowProfile
  | ShowTrack String
  | EditTrack String
  | PlayTrack String


routeParsers : Parsers Route
routeParsers =
  [ static Home "/"
  , static Login "/login"
  , static Register "/register"
  , static ShowProfile "/me"
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
    ShowTrack id -> "/track/" ++ id
    EditTrack id -> "/edit/" ++ id
    PlayTrack id -> "/play/" ++ id



-- showTrack : AppState -> String -> AppUpdate
-- showTrack appState slug =
--   mapAppUpdate appState ShowTrackScreen (ShowTrack.mount slug)


-- editTrack : AppState -> String -> AppUpdate
-- editTrack appState slug =
--   mapAppUpdate appState EditTrackScreen (EditTrack.mount appState.dims slug)



-- notFound : AppState -> String -> AppUpdate
-- notFound appState path =
--   AppUpdate { appState | screen <- NotFoundScreen path } Nothing Nothing


-- path changes

-- pathChangeMailbox : Signal.Mailbox (Task error ())
-- pathChangeMailbox = Signal.mailbox (Task.succeed ())


-- changePath : String -> Task error ()
-- changePath path =
--   Signal.send pathChangeMailbox.address (History.setPath path)
