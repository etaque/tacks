module Routes where

import Task exposing (Task,andThen)

import Router exposing (..)
import Http

import State exposing (..)
import Core exposing (find)
import ServerApi
import Inputs exposing (actionsMailbox)


type alias ScreenLoader = Task Http.Error Screen

pathChangeMailbox : Signal.Mailbox (Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())

pathToScreenTask : AppState -> String -> Task Http.Error ()
pathToScreenTask appState path =
  (route appState path)
    `andThen` (\screen -> Signal.send actionsMailbox.address (Inputs.Navigate screen))

route : AppState -> Route ScreenLoader
route {player,courses} =
  match
    [ "/" :-> to Home
    , "/login" :-> to Login
    , "/me" :-> to (ShowProfile player)
    , "/profile/" :-> showProfile
    , "/show-course/" :-> showCourse courses
    , "/play/" :-> playCourse courses
    ] (to NotFound)

showProfile : String -> ScreenLoader
showProfile id =
  ServerApi.getPlayer id
    |> Task.map ShowProfile


showCourse : List RaceCourseStatus -> String -> ScreenLoader
showCourse courses slug =
  case find (\{raceCourse} -> raceCourse.slug == slug) courses of
    Just raceCourseStatus -> go (Show raceCourseStatus)
    Nothing -> go NotFound

playCourse : List RaceCourseStatus -> String -> ScreenLoader
playCourse courses slug =
  case find (\{raceCourse} -> raceCourse.slug == slug) courses of
    Just raceCourseStatus -> go (Play raceCourseStatus.raceCourse)
    Nothing -> go NotFound


-- Tooling

go : Screen -> ScreenLoader
go screen =
  Task.succeed screen

to : Screen -> String -> ScreenLoader
to screen _ =
  Task.succeed screen
