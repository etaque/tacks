module Page.Home.Update exposing (..)

import Response exposing (..)
import Dialog
import Model.Shared exposing (..)
import Page.Home.Model exposing (..)
import ServerApi
import Update.Utils exposing (..)
import Model.Event as Event
import Http


subscriptions : String -> Model -> Sub Msg
subscriptions host model =
    Sub.batch
        [ Sub.map DialogMsg (Dialog.subscriptions model.dialog)
        ]


mount : Model -> Response Model Msg
mount model =
    res model loadRaceReports


update : String -> Player -> Msg -> Model -> Response Model Msg
update host player msg model =
    case msg of
        RaceReportsResult result ->
            res
                { model | raceReports = httpData result }
                Cmd.none

        Poke target ->
            if canPoke target player then
                res
                    { model | pokes = target.id :: model.pokes }
                    (delayMsg 1000 (PokeEnd target.id))
                    |> withEvent (Event.Poke target)
            else
                res model Cmd.none

        PokeEnd id ->
            let
                pokes =
                    List.filter ((/=) id) model.pokes
            in
                res { model | pokes = pokes } Cmd.none

        ShowDialog content ->
            Dialog.taggedOpen DialogMsg { model | showDialog = content }
                |> toResponse

        DialogMsg a ->
            Dialog.taggedUpdate DialogMsg a model
                |> toResponse

        NoOp ->
            res model Cmd.none


loadRaceReports : Cmd Msg
loadRaceReports =
    ServerApi.getRaceReports Nothing
        |> Http.send RaceReportsResult
