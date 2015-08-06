module Routes where

import Task exposing (Task, andThen, map)

import Router exposing (..)
import Http


import Screens.Home.HomeUpdates as Home
import Screens.Register.RegisterUpdates as Register
import Screens.Login.LoginUpdates as Login

import AppTypes exposing (..)





-- import Models exposing (..)
-- import Core exposing (find)
-- import ServerApi
-- import Inputs exposing (actionsMailbox)
-- import Debug

-- type alias ScreenLoader = Task Http.Error Screen

pathChangeMailbox : Signal.Mailbox (Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())

-- pathToScreenTask : AppState -> String -> Task Http.Error ()
-- pathToScreenTask appState path =
--   (route appState path)
--     `andThen` (\screen -> Signal.send actionsMailbox.address (Inputs.Navigate screen))

route : AppState -> Route AppUpdate
route appState =
  match
    [ "/" :-> home appState
    , "/login" :-> login appState
    , "/register" :-> register appState
    -- , "/me" :-> to (ShowProfile player)
    -- , "/profile/" :-> showProfile
    -- , "/show-course/" :-> showCourse
    -- , "/play/" :-> playCourse
    ] (notFound appState)


home : AppState -> String -> AppUpdate
home appState _ =
  screenToAppUpdate appState HomeScreen HomeAction (Home.mount appState.player)


register : AppState -> String -> AppUpdate
register appState _ =
  screenToAppUpdate appState RegisterScreen RegisterAction Register.mount


login : AppState -> String -> AppUpdate
login appState _ =
  screenToAppUpdate appState LoginScreen LoginAction Login.mount


notFound : AppState -> String -> AppUpdate
notFound appState path =
  AppUpdate { appState | screen <- NotFoundScreen path } Nothing Nothing


-- showProfile : String -> ScreenLoader
-- showProfile handle =
--   ServerApi.getPlayer handle
--     |> map ShowProfile


-- showCourse : String -> ScreenLoader
-- showCourse slug =
--   ServerApi.getRaceCourseStatus slug
--     |> map Show

-- playCourse : String -> ScreenLoader
-- playCourse slug =
--   ServerApi.getRaceCourse slug
--     |> map Play


-- -- Tooling

-- to : Screen -> String -> ScreenLoader
-- to screen _ =
--   Task.succeed screen
