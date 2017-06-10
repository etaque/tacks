module Page.EditTrack.Update exposing (..)

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Response exposing (..)
import Model.Shared exposing (..)
import Page.EditTrack.Model exposing (..)
import Page.EditTrack.FormUpdate as FormUpdate
import Page.EditTrack.GridUpdate as GridUpdate
import ServerApi
import Update.Utils exposing (..)
import Route
import Mouse
import Http
import Window
import Game.Utils


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map MouseMsg (Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ])


mount : String -> Res Model Msg
mount id =
    res initial (loadTrack id)


update : Window.Size -> Msg -> Model -> Res Model Msg
update size msg model =
    case msg of
        LoadTrack result ->
            case result of
                Ok ( track, course ) ->
                    res
                        { model
                            | track = Just track
                            , editor = Just (initialEditor track course)
                        }
                        Cmd.none

                _ ->
                    res { model | notFound = True } Cmd.none

        SetTab tab ->
            res (updateEditor (\e -> { e | tab = tab }) model) Cmd.none

        SetName n ->
            res (updateEditor (\e -> { e | name = n }) model) Cmd.none

        MouseMsg mouseMsg ->
            res (updateEditor (GridUpdate.updateMouse mouseMsg size) model) Cmd.none

        SetMode mode ->
            res (updateEditor (\e -> { e | mode = mode }) model) Cmd.none

        AltMoveMode b ->
            res (updateEditor (\e -> { e | altMove = b }) model) Cmd.none

        FormMsg a ->
            res ((FormUpdate.update >> updateEditor) a model) Cmd.none

        Save try ->
            case ( model.track, model.editor ) of
                ( Just track, Just editor ) ->
                    res (updateEditor (\e -> { e | saving = True }) model) (save try track.id editor)

                _ ->
                    res model Cmd.none

        SaveResult try result ->
            case result of
                Ok track ->
                    let
                        newModel =
                            updateEditor (\e -> { e | saving = False }) model

                        effect =
                            if try then
                                navigate (Route.PlayTrack track.id)
                            else
                                Cmd.none
                    in
                        res newModel effect

                Err _ ->
                    res model Cmd.none

        ConfirmPublish ->
            res (updateEditor (\e -> { e | confirmPublish = not e.confirmPublish }) model) Cmd.none

        Publish ->
            case ( model.track, model.editor ) of
                ( Just track, Just editor ) ->
                    res
                        (updateEditor (\e -> { e | saving = True }) model)
                        (publish track.id editor)

                _ ->
                    res model Cmd.none

        NoOp ->
            res model Cmd.none


updateEditor : (Editor -> Editor) -> Model -> Model
updateEditor update model =
    let
        newEditor =
            Maybe.map update model.editor
    in
        { model | editor = newEditor }


loadTrack : String -> Cmd Msg
loadTrack id =
    Task.map2 (,) (Http.toTask (ServerApi.getTrack id)) (Http.toTask (ServerApi.getCourse id))
        |> Task.attempt LoadTrack


saveEditor : String -> Editor -> Task Never (FormResult Track)
saveEditor id ({ course, name } as editor) =
    let
        area =
            listGridTiles course.grid
                |> List.filter (\t -> t.kind == Water)
                |> Game.Utils.getRaceArea
    in
        ServerApi.saveTrack id name { course | area = area } |> ServerApi.toFormTask


save : Bool -> String -> Editor -> Cmd Msg
save try id editor =
    delay 500 (saveEditor id editor)
        |> Task.perform (SaveResult try)


publish : String -> Editor -> Cmd Msg
publish id ({ course, name } as editor) =
    delay 500 (saveEditor id editor)
        |> Task.andThen (\_ -> (ServerApi.toFormTask (ServerApi.publishTrack id)))
        |> Task.perform (SaveResult True)
