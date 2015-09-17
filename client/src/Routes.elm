module Routes where

import Task exposing (Task, andThen, map)

import Router exposing (..)
import Http
import History

import Screens.Home.Updates as Home
import Screens.Register.Updates as Register
import Screens.Login.Updates as Login
import Screens.ShowTrack.Updates as ShowTrack
import Screens.ShowProfile.Updates as ShowProfile
import Screens.Game.Updates as Game
import Screens.EditTrack.Updates as EditTrack

import AppTypes exposing (..)


route : AppState -> Route AppUpdate
route appState =
  match
    [ "/" :-> home appState
    , "/login" :-> login appState
    , "/register" :-> register appState
    , "/me" :-> showProfile appState
    -- , "/profile/" :-> showProfile
    , "/track/" :-> showTrack appState
    , "/editor/" :-> editTrack appState
    , "/play/" :-> playTrack appState
    ] (notFound appState)


home : AppState -> String -> AppUpdate
home appState _ =
  mapAppUpdate appState HomeScreen (Home.mount appState.player)


register : AppState -> String -> AppUpdate
register appState _ =
  mapAppUpdate appState RegisterScreen Register.mount


login : AppState -> String -> AppUpdate
login appState _ =
  mapAppUpdate appState LoginScreen Login.mount


showTrack : AppState -> String -> AppUpdate
showTrack appState slug =
  mapAppUpdate appState ShowTrackScreen (ShowTrack.mount slug)


editTrack : AppState -> String -> AppUpdate
editTrack appState slug =
  mapAppUpdate appState EditTrackScreen (EditTrack.mount appState.dims slug)


showProfile : AppState -> String -> AppUpdate
showProfile appState _ =
  mapAppUpdate appState ShowProfileScreen (ShowProfile.mount appState.player)



playTrack : AppState -> String -> AppUpdate
playTrack appState slug =
  mapAppUpdate appState GameScreen (Game.mount slug)


notFound : AppState -> String -> AppUpdate
notFound appState path =
  AppUpdate { appState | screen <- NotFoundScreen path } Nothing Nothing


-- path changes

pathChangeMailbox : Signal.Mailbox (Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())


changePath : String -> Task error ()
changePath path =
  Signal.send pathChangeMailbox.address (History.setPath path)
