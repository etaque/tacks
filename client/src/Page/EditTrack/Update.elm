module Page.EditTrack.Update exposing (..)

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Array
import Response exposing (..)
import Model.Shared exposing (..)
import Page.EditTrack.Model exposing (..)
import Page.EditTrack.FormUpdate as FormUpdate
import Page.EditTrack.GridUpdate as GridUpdate
import Constants exposing (..)
import ServerApi
import Hexagons
import CoreExtra
import Location
import Route
import Mouse


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.map MouseMsg (Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ])


mount : String -> Res Model Msg
mount id =
  res initial (loadTrack id)


update : Dims -> Msg -> Model -> Res Model Msg
update dims msg model =
  case msg of
    LoadTrack trackResult courseResult ->
      case ( trackResult, courseResult ) of
        ( Ok track, Ok course ) ->
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
      res (updateEditor (GridUpdate.updateMouse mouseMsg dims) model) Cmd.none

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
                Location.navigate (Route.PlayTrack track.id)
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
  Task.map2 LoadTrack (ServerApi.getTrack id) (ServerApi.getCourse id)
    |> CoreExtra.performSucceed identity


saveEditor : String -> Editor -> Task Never (FormResult Track)
saveEditor id ({ course, name } as editor) =
  ServerApi.saveTrack id name { course | area = getRaceArea course.grid }


save : Bool -> String -> Editor -> Cmd Msg
save try id editor =
  CoreExtra.delay 500 (saveEditor id editor)
    |> CoreExtra.performSucceed (SaveResult try)


publish : String -> Editor -> Cmd Msg
publish id ({ course, name } as editor) =
  CoreExtra.delay 500 (saveEditor id editor)
    `andThen` (\_ -> ServerApi.publishTrack id)
    |> CoreExtra.performSucceed (SaveResult True)


getRaceArea : Grid -> RaceArea
getRaceArea grid =
  let
    waterPoints =
      listGridTiles grid
        |> List.filter (\t -> t.kind == Water)
        |> List.map (\t -> Hexagons.axialToPoint hexRadius t.coords)

    xVals =
      waterPoints
        |> List.map fst
        |> List.sort
        |> Array.fromList

    yVals =
      waterPoints
        |> List.map snd
        |> List.sort
        |> Array.fromList

    getFirst arr =
      Maybe.withDefault 0 (Array.get 0 arr)

    getLast arr =
      Maybe.withDefault 0 (Array.get (Array.length arr - 1) arr)

    right =
      getLast xVals + hexRadius

    left =
      getFirst xVals - hexRadius

    top =
      getLast yVals + hexRadius

    bottom =
      getFirst yVals - hexRadius
  in
    RaceArea ( right, top ) ( left, bottom )
