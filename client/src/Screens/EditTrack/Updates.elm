module Screens.EditTrack.Updates where

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Effects exposing (Effects, Never, none)
import Task.Extra exposing (delay)
import Keyboard
import Array

import DragAndDrop exposing (mouseEvents)

import AppTypes exposing (..)
import Models exposing (..)

import Screens.EditTrack.Types exposing (..)
import Screens.EditTrack.FormUpdates as FormUpdates exposing (update)
import Screens.EditTrack.GridUpdates as GridUpdates exposing (mouseAction)

import Constants exposing (..)
import ServerApi
import Screens.UpdateUtils as Utils
import Routes

import Hexagons
import Hexagons.Grid as Grid


addr : Signal.Address Action
addr =
  Utils.screenAddr EditTrackAction


inputs : Signal Action
inputs =
  Signal.mergeMany
    [ Signal.map AltMoveMode Keyboard.shift
    , Signal.map MouseAction mouseEvents
    ]

mount : String -> (Screen, Effects Action)
mount id =
  initial &! (loadTrack id)


update : Dims -> Action -> Screen -> (Screen, Effects Action)
update dims action screen =
  case action of

    LoadTrack result ->
      case result of
        Ok track ->
          { screen | track = Just track, editor = Just (initialEditor track) } &: none
        Err _ ->
          { screen | notFound = True } &: none

    ToggleBlock b ->
      (updateBlocks >> updateEditor) b screen &: none

    SetName n ->
      (updateEditor (\e -> { e | name = n }) screen) &: none

    MouseAction event ->
      updateEditor (GridUpdates.mouseAction event dims) screen &: none

    SetMode mode ->
      updateEditor (\e -> { e | mode = mode }) screen &: none

    AltMoveMode b ->
      updateEditor (\e -> { e | altMove = b }) screen &: none

    FormAction a ->
      (FormUpdates.update >> updateCourse >> updateEditor) a screen &: none

    Save try ->
      case (screen.track, screen.editor) of
        (Just track, Just editor) ->
          (updateEditor (\e -> { e | saving = True}) screen) &! (save try track.id editor)
        _ ->
          screen &: none

    SaveResult try result ->
      case result of
        Ok track ->
          let
            newScreen = updateEditor (\e -> { e | saving = False }) screen
            effect = if try
              then Effects.map (\_ -> NoOp) (Utils.redirect (Routes.PlayTrack track.id))
              else none
          in
            newScreen &: effect
        Err _ ->
          screen &: none -- TODO

    ConfirmPublish ->
      updateEditor (\e -> { e | confirmPublish = not e.confirmPublish }) screen &: none

    Publish ->
      case (screen.track, screen.editor) of
        (Just track, Just editor) ->
          (updateEditor (\e -> { e | saving = True}) screen) &! (publish track.id editor)
        _ ->
          screen &: none

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

updateBlocks : SideBlock -> Editor -> Editor
updateBlocks b ({blocks} as editor) =
  let
    newBlocks = case b of
      Name -> { blocks | name = not blocks.name }
      Surface -> { blocks | surface = not blocks.surface }
      Gates -> { blocks | gates = not blocks.gates }
      Wind -> { blocks | wind = not blocks.wind }
      Gusts -> { blocks | gusts = not blocks.gusts }
  in
    { editor | blocks = newBlocks }


loadTrack : String -> Task Never Action
loadTrack id =
  ServerApi.getTrack id
    |> Task.map LoadTrack


saveEditor : String -> Editor -> Task Never (FormResult Track)
saveEditor id ({course, name} as editor) =
  ServerApi.saveTrack id name { course | area = getRaceArea course.grid }


save : Bool -> String -> Editor -> Task Never Action
save try id editor =
  delay 500 (saveEditor id editor)
    |> Task.map (SaveResult try)


publish : String -> Editor -> Task Never Action
publish id ({course, name} as editor) =
  delay 500 (saveEditor id editor) `andThen` (\_ -> ServerApi.publishTrack id)
    |> Task.map (SaveResult True)


getRaceArea : Grid -> RaceArea
getRaceArea grid =
  let
    waterPoints = Grid.list grid
      |> List.filter (\t -> t.content == Water)
      |> List.map (\t -> Hexagons.axialToPoint hexRadius t.coords)

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
