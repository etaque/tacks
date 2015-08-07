module Routes where

import Task exposing (Task, andThen, map)

import Router exposing (..)
import Http
import History

import Screens.Home.HomeUpdates as Home
import Screens.Register.RegisterUpdates as Register
import Screens.Login.LoginUpdates as Login
import Screens.ShowTrack.ShowTrackUpdates as ShowTrack

import AppTypes exposing (..)


pathChangeMailbox : Signal.Mailbox (Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())


changePath : String -> Task error ()
changePath path =
  Signal.send pathChangeMailbox.address (History.setPath path)


route : AppState -> Route AppUpdate
route appState =
  match
    [ "/" :-> home appState
    , "/login" :-> login appState
    , "/register" :-> register appState
    -- , "/me" :-> to (ShowProfile player)
    -- , "/profile/" :-> showProfile
    , "/track/" :-> showTrack appState
    -- , "/play/" :-> playCourse
    ] (notFound appState)


home : AppState -> String -> AppUpdate
home appState _ =
  screenToAppUpdate appState HomeScreen (Home.mount appState.player)


register : AppState -> String -> AppUpdate
register appState _ =
  screenToAppUpdate appState RegisterScreen Register.mount


login : AppState -> String -> AppUpdate
login appState _ =
  screenToAppUpdate appState LoginScreen Login.mount


showTrack : AppState -> String -> AppUpdate
showTrack appState slug =
  screenToAppUpdate appState ShowTrackScreen (ShowTrack.mount slug)


notFound : AppState -> String -> AppUpdate
notFound appState path =
  AppUpdate { appState | screen <- NotFoundScreen path } Nothing Nothing


-- showProfile : String -> ScreenLoader
-- showProfile handle =
--   ServerApi.getPlayer handle
--     |> map ShowProfile


-- playCourse : String -> ScreenLoader
-- playCourse slug =
--   ServerApi.getRaceCourse slug
--     |> map Play


-- -- Tooling

-- to : Screen -> String -> ScreenLoader
-- to screen _ =
--   Task.succeed screen
