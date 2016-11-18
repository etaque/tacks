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


always : msg -> Cmd a -> Cmd msg
always msg effect =
    Cmd.map (\_ -> msg) effect


performSucceed : (a -> msg) -> Task Never a -> Cmd msg
performSucceed =
    Task.perform


toCmd : msg -> Cmd msg
toCmd msg =
    performSucceed identity (Task.succeed msg)


never : Never -> a
never n =
    never n


delay : Time -> Task x a -> Task x a
delay t task =
    Process.sleep t |> Task.andThen (\_ -> task)


delayMsg : Time -> msg -> Cmd msg
delayMsg t msg =
    performSucceed identity (delay t (Task.succeed msg))


httpData : HttpResult a -> HttpData a
httpData res =
    case res of
        Ok data ->
            DataOk data

        Err e ->
            DataErr e
