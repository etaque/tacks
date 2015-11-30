module Routes where

import Task exposing (Task, andThen, map)

import Http
import History
import RouteParser exposing (..)

import Screens.Home.Updates as HomeScreen
import Screens.Register.Updates as RegisterScreen
import Screens.Login.Updates as LoginScreen
import Screens.ShowTrack.Updates as ShowTrackScreen
import Screens.ShowProfile.Updates as ShowProfileScreen
import Screens.Game.Updates as GameScreen
import Screens.EditTrack.Updates as EditTrackScreen

import AppTypes exposing (..)


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

-- route : AppState -> Route AppUpdate
-- route appState =
--   match
--     [ "/" :-> home appState
--     , "/login" :-> login appState
--     , "/register" :-> register appState
--     , "/me" :-> showProfile appState
--     , "/track/" :-> showTrack appState
--     , "/edit/" :-> editTrack appState
--     , "/play/" :-> playTrack appState
--     ] (notFound appState)


-- home : AppState -> String -> AppUpdate
-- home appState _ =
--   mapAppUpdate appState HomeScreen (Home.mount appState.player)


-- register : AppState -> String -> AppUpdate
-- register appState _ =
--   mapAppUpdate appState RegisterScreen Register.mount


-- login : AppState -> String -> AppUpdate
-- login appState _ =
--   mapAppUpdate appState LoginScreen Login.mount


-- showTrack : AppState -> String -> AppUpdate
-- showTrack appState slug =
--   mapAppUpdate appState ShowTrackScreen (ShowTrack.mount slug)


-- editTrack : AppState -> String -> AppUpdate
-- editTrack appState slug =
--   mapAppUpdate appState EditTrackScreen (EditTrack.mount appState.dims slug)


-- showProfile : AppState -> String -> AppUpdate
-- showProfile appState _ =
--   mapAppUpdate appState ShowProfileScreen (ShowProfile.mount appState.player)



-- playTrack : AppState -> String -> AppUpdate
-- playTrack appState slug =
--   mapAppUpdate appState GameScreen (Game.mount slug)


-- notFound : AppState -> String -> AppUpdate
-- notFound appState path =
--   AppUpdate { appState | screen <- NotFoundScreen path } Nothing Nothing


-- path changes

pathChangeMailbox : Signal.Mailbox (Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())


changePath : String -> Task error ()
changePath path =
  Signal.send pathChangeMailbox.address (History.setPath path)
