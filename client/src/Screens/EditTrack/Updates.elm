module Screens.EditTrack.Updates where

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Effects exposing (Effects, Never, none)
import Task.Extra exposing (delay)
import Keyboard
import Array

import DragAndDrop exposing (mouseEvents)

import Constants exposing (sidebarWidth)
import AppTypes exposing (..)
import Models exposing (..)

import Screens.EditTrack.Types exposing (..)
import Screens.EditTrack.FormUpdates as FormUpdates exposing (update)
import Screens.EditTrack.GridUpdates as GridUpdates exposing (mouseAction)

import Game.Grid exposing (..)
import ServerApi
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr EditTrackAction


inputs : Signal Action
inputs =
  Signal.mergeMany
    [ Signal.map AltMoveMode Keyboard.shift
    , Signal.map MouseAction mouseEvents
    ]

mount : Dims -> String -> (Screen, Effects Action)
mount dims id =
  (initial dims) &! (loadTrack id)


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    LoadTrack result ->
      case result of
        Ok track ->
          let
            editor =
              { course = track.course
              , center = (0, 0)
              , courseDims = getCourseDims screen.dims
              , mode = Watch
              , altMove = False
              , name = track.name
              , saving = False
              }
          in
            { screen | track = Just track, editor = Just editor } &: none
        Err _ ->
        { screen | notFound = True } &: none

    SetName n ->
      (updateEditor (\e -> { e | name = n }) screen) &: none

    MouseAction event ->
      (GridUpdates.mouseAction >> updateEditor) event screen &: none

    SetMode mode ->
      updateEditor (\e -> { e | mode = mode }) screen &: none

    AltMoveMode b ->
      updateEditor (\e -> { e | altMove = b }) screen &: none

    FormAction a ->
      (FormUpdates.update >> updateCourse >> updateEditor) a screen &: none

    Save ->
      case (screen.track, screen.editor) of
        (Just track, Just editor) ->
          (updateEditor (\e -> { e | saving = True}) screen) &! (save track.id editor)
        _ ->
          screen &: none

    SaveResult result -> -- TODO
      updateEditor (\e -> { e | saving = False }) screen &: none

    NoOp ->
      screen &: none


updateEditor : (Editor -> Editor) -> Screen -> Screen
updateEditor update screen =
  let
    newEditor = Maybe.map update screen.editor
  in
    { screen | editor = newEditor }


updateCourse : (Course -> Course) -> Editor -> Editor
updateCourse update editor =
  { editor | course = update editor.course }


loadTrack : String -> Task Never Action
loadTrack id =
  ServerApi.getTrack id
    |> Task.map LoadTrack


updateDims : Dims -> Screen -> Screen
updateDims dims screen =
  let
    newEditor = Maybe.map (\e -> { e | courseDims = getCourseDims dims } ) screen.editor
  in
    { screen | editor = newEditor, dims = dims }


getCourseDims : Dims -> Dims
getCourseDims (w, h) =
  (w - sidebarWidth, h)


save : String -> Editor -> Task Never Action
save id ({course, name} as editor) =
  let
    area = getRaceArea course.grid
    withArea = { course | area = area }
  in
    delay 500 (ServerApi.saveTrack id name withArea)
      |> Task.map SaveResult 


getRaceArea : Grid -> RaceArea
getRaceArea grid =
  let
    waterPoints = getTilesList grid
      |> List.filter (\t -> t.kind == Water)
      |> List.map (\t -> hexCoordsToPoint t.coords)

    xVals = waterPoints
      |> List.map fst
      |> List.sort
      |> Array.fromList

    yVals = waterPoints
      |> List.map snd
      |> List.sort
      |> Array.fromList

    getFirst arr = Maybe.withDefault 0 (Array.get 0 arr)
    getLast arr = Maybe.withDefault 0 (Array.get (Array.length arr - 1) arr)

    right = getLast xVals + hexRadius
    left = getFirst xVals - hexRadius

    top = getLast yVals + hexRadius
    bottom = getFirst yVals - hexRadius
  in
    RaceArea (right, top) (left, bottom)
