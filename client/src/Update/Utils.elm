module Update.Utils exposing (..)

import Task exposing (Task)
import Time exposing (Time)
import Process
import Navigation
import Route exposing (Route)
import Model.Shared exposing (..)


navigate : Route -> Cmd msg
navigate route =
    Navigation.newUrl (Route.toPath route)


delay : Time -> Task x a -> Task x a
delay t task =
    Process.sleep t |> Task.andThen (\_ -> task)


delayMsg : Time -> msg -> Cmd msg
delayMsg t msg =
    Task.perform identity (delay t (Task.succeed msg))


httpData : HttpResult a -> HttpData a
httpData res =
    case res of
        Ok data ->
            DataOk data

        Err e ->
            DataErr e
