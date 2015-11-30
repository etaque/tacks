module Screens.EditTrack.Updates where

import Task exposing (Task, succeed, map, andThen)
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


addr : Signal.Address Action
addr =
  Signal.forwardTo appActionsMailbox.address (EditTrackAction >> ScreenAction)


inputs : Signal Action
inputs =
  Signal.mergeMany
    [ Signal.map AltMoveMode Keyboard.shift
    , Signal.map MouseAction mouseEvents
    ]

type alias Update = AppTypes.ScreenUpdate Screen


mount : Dims -> String -> Update
mount dims id =
  let
    initial =
      { track = Nothing
      , editor = Nothing
      , notFound = False
      , dims = dims
      }
  in
    react initial (loadTrack id)


update : Action -> Screen -> Update
update action screen =
  case action of

    SetTrack track ->
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
        local { screen | track = Just track, editor = Just editor }

    TrackNotFound ->
      local { screen | notFound = True }

    SetName n ->
      screen
        |> updateEditor (\e -> { e | name = n })
        |> local

    MouseAction event ->
      screen
        |> (GridUpdates.mouseAction >> updateEditor) event
        |> local

    SetMode mode ->
      screen
        |> updateEditor (\e -> { e | mode = mode })
        |> local

    AltMoveMode b ->
      screen
        |> updateEditor (\e -> { e | altMove = b })
        |> local

    FormAction a ->
      screen
        |> (FormUpdates.update >> updateCourse >> updateEditor) a
        |> local

    Save ->
      case (screen.track, screen.editor) of
        (Just track, Just editor) ->
          react (updateEditor (\e -> { e | saving = True}) screen) (save track.id editor)
        _ ->
          local screen

    SaveResult _ ->
      screen
        |> updateEditor (\e -> { e | saving = False })
        |> local


updateEditor : (Editor -> Editor) -> Screen -> Screen
updateEditor update screen =
  let
    newEditor = Maybe.map update screen.editor
  in
    { screen | editor = newEditor }


updateCourse : (Course -> Course) -> Editor -> Editor
updateCourse update editor =
  { editor | course = update editor.course }


loadTrack : String -> Task Never ()
loadTrack id =
  ServerApi.getTrack id `andThen`
    \result ->
      case result of
        Ok track ->
          Signal.send addr (SetTrack track)
        Err _ ->
          Task.succeed ()


updateDims : Dims -> Screen -> Screen
updateDims dims screen =
  let
    newEditor = Maybe.map (\e -> { e | courseDims = getCourseDims dims } ) screen.editor
  in
    { screen | editor = newEditor, dims = dims }


getCourseDims : Dims -> Dims
getCourseDims (w, h) =
  (w - sidebarWidth, h)


save : String -> Editor -> Task Never ()
save id ({course, name} as editor) =
  let
    area = getRaceArea course.grid
    withArea = { course | area = area }
  in
    delay 500 (ServerApi.saveTrack id name withArea)
      `andThen` (SaveResult >> (Signal.send addr))


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
