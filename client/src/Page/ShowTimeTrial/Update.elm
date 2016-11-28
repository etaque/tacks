module Page.ShowTimeTrial.Update exposing (..)

import Model.Shared exposing (..)
import Page.ShowTimeTrial.Model exposing (..)
import Response exposing (..)
import ServerApi
import Http


mount : String -> Response Model Msg
mount id =
    res initial (load id)


update : Player -> Msg -> Model -> Response Model Msg
update player msg model =
    case msg of
        Load result ->
            case result of
                Ok liveTimeTrial ->
                    res { model | liveTimeTrial = DataOk liveTimeTrial } Cmd.none

                Err e ->
                    res { model | liveTimeTrial = DataErr e } Cmd.none


load : String -> Cmd Msg
load id =
    (ServerApi.getLiveTimeTrial (Just id))
        |> Http.send Load
