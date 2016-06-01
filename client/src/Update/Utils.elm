module Update.Utils exposing (..)

import Task exposing (Task)
import Time exposing (Time)
import Process
import Navigation
import Route exposing (Route)


navigate : Route -> Cmd msg
navigate route =
  Navigation.newUrl (Route.toPath route)


always : msg -> Cmd a -> Cmd msg
always msg effect =
  Cmd.map (\_ -> msg) effect


performSucceed : (a -> msg) -> Task Never a -> Cmd msg
performSucceed =
  Task.perform never


toCmd : msg -> Cmd msg
toCmd msg =
  performSucceed identity (Task.succeed msg)


never : Never -> a
never n =
  never n


delay : Time -> Task x a -> Task x a
delay t task =
  Process.sleep t `Task.andThen` (\_ -> task)
