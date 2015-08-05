module Routes where

import Task exposing (Task, andThen, map)

import Router exposing (..)
import Http

import State exposing (..)
import Core exposing (find)
import ServerApi
import Inputs exposing (actionsMailbox)
import Debug

type alias ScreenLoader = Task Http.Error Screen

pathChangeMailbox : Signal.Mailbox (Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())

pathToScreenTask : AppState -> String -> Task Http.Error ()
pathToScreenTask appState path =
  (route appState path)
    `andThen` (\screen -> Signal.send actionsMailbox.address (Inputs.Navigate screen))

route : AppState -> Route ScreenLoader
route {player} =
  match
    [ "/" :-> to Home
    , "/login" :-> to Login
    , "/register" :-> to Register
    , "/me" :-> to (ShowProfile player)
    , "/profile/" :-> showProfile
    , "/show-course/" :-> showCourse
    , "/play/" :-> playCourse
    ] (to NotFound)

showProfile : String -> ScreenLoader
showProfile handle =
  ServerApi.getPlayer handle
    |> map ShowProfile


showCourse : String -> ScreenLoader
showCourse slug =
  ServerApi.getRaceCourseStatus slug
    |> map Show

playCourse : String -> ScreenLoader
playCourse slug =
  ServerApi.getRaceCourse slug
    |> map Play


-- Tooling

to : Screen -> String -> ScreenLoader
to screen _ =
  Task.succeed screen
