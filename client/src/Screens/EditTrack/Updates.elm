module Screens.EditTrack.Updates where

import Task exposing (Task, succeed, map, andThen)
import Task.Extra exposing (delay)
import Time exposing (second)
import Http
import Keyboard
import Array

import DragAndDrop exposing (mouseEvents)

import Constants exposing (sidebarWidth)
import AppTypes exposing (local, react, request, Never)
import Models exposing (..)

import Screens.EditTrack.Types exposing (..)
import Screens.EditTrack.FormUpdates as FormUpdates exposing (update)
import Screens.EditTrack.GridUpdates as GridUpdates exposing (mouseAction)

import Game.Grid exposing (..)
import ServerApi


actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp

inputs : Signal Action
inputs =
  Signal.mergeMany
    [ Signal.map (\b -> if b then NextTileKind else NoOp) Keyboard.space
    , Signal.map (\b -> if b then EscapeMode else NoOp) (Keyboard.isDown 27)
    , Signal.map MouseAction mouseEvents
    ]

type alias Update = AppTypes.ScreenUpdate Screen


mount : Dims -> String -> Update
mount dims slug =
  let
    initial =
      { track = Nothing
      , editor = Nothing
      , notFound = False
      , dims = dims
      }
  in
    react initial (loadTrack slug)


update : Action -> Screen -> Update
update action screen =
  case action of

    SetTrack track ->
      let
        editor =
          { course = track.course
          , center = (0, 0)
          , courseDims = getCourseDims screen.dims
          , mode = CreateTile Water
          }
      in
        local { screen | track <- Just track, editor <- Just editor }

    TrackNotFound ->
      local { screen | notFound <- True }

    MouseAction event ->
      screen
        |> (GridUpdates.mouseAction >> updateEditor) event
        |> local

    NextTileKind ->
      screen
        |> updateEditor (\e -> { e | mode <- getNextMode e.mode })
        |> local

    EscapeMode ->
      screen
        |> updateEditor (\e -> { e | mode <- Watch })
        |> local

    FormAction a ->
      screen
        |> (FormUpdates.update >> updateCourse >> updateEditor) a
        |> local

    Save ->
      case (screen.track, screen.editor) of
        (Just track, Just editor) ->
          react screen (save track.slug editor)
        _ ->
          local screen

    _ ->
      local screen


updateEditor : (Editor -> Editor) -> Screen -> Screen
updateEditor update screen =
  let
    newEditor = Maybe.map update screen.editor
  in
    { screen | editor <- newEditor }

updateCourse : (Course -> Course) -> Editor -> Editor
updateCourse update editor =
  { editor | course <- update editor.course }

loadTrack : String -> Task Never ()
loadTrack slug =
  ServerApi.getTrack slug `andThen`
    \result ->
      case result of
        Ok track ->
          Signal.send actions.address (SetTrack track)
        Err _ ->
          Task.succeed ()


updateDims : Dims -> Screen -> Screen
updateDims dims screen =
  let
    newEditor = Maybe.map (\e -> { e | courseDims <- getCourseDims dims } ) screen.editor
  in
    { screen | editor <- newEditor, dims <- dims }

getCourseDims : Dims -> Dims
getCourseDims (w, h) =
  (w - sidebarWidth, h)


getNextMode : Mode -> Mode
getNextMode mode =
  case mode of
    CreateTile Water ->
      CreateTile Grass
    CreateTile Grass ->
      CreateTile Rock
    CreateTile Rock ->
      Erase
    _ ->
      CreateTile Water

save : String -> Editor -> Task Never ()
save slug ({course} as editor) =
  let
    area = getRaceArea course.grid
    withArea = { course | area <- area }
  in
    ServerApi.saveTrack slug withArea `andThen`
      \result -> Task.succeed ()

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
