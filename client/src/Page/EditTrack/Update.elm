module Page.EditTrack.Update where

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Effects exposing (Effects, Never, none)
import Task.Extra exposing (delay)
import Keyboard
import Array
import Response exposing (..)
import DragAndDrop exposing (MouseEvent)

import AppTypes exposing (..)
import Models exposing (..)

import Page.EditTrack.Model exposing (..)
import Page.EditTrack.FormUpdate as FormUpdate
import Page.EditTrack.GridUpdate as GridUpdate

import Constants exposing (..)
import ServerApi
import Page.UpdateUtils as Utils
import Route

import Hexagons
import Hexagons.Grid as Grid


addr : Signal.Address Action
addr =
  Utils.screenAddr EditTrackAction


inputs : Signal Action
inputs =
  Signal.mergeMany
    [ Signal.map AltMoveMode Keyboard.shift
    ]

mouseAction : MouseEvent -> Action
mouseAction =
  MouseAction

mount : String -> (Screen, Effects Action)
mount id =
  taskRes initial (loadTrack id)


update : Dims -> Action -> Screen -> (Screen, Effects Action)
update dims action screen =
  case action of

    LoadTrack result ->
      case result of
        Ok track ->
          staticRes { screen | track = Just track, editor = Just (initialEditor track) }
        Err _ ->
          staticRes { screen | notFound = True }

    ToggleBlock b ->
      staticRes ((updateBlocks >> updateEditor) b screen)

    SetName n ->
      staticRes (updateEditor (\e -> { e | name = n }) screen)

    MouseAction event ->
      staticRes (updateEditor (GridUpdate.mouseAction event dims) screen)

    SetMode mode ->
      staticRes (updateEditor (\e -> { e | mode = mode }) screen)

    AltMoveMode b ->
      staticRes (updateEditor (\e -> { e | altMove = b }) screen)

    FormAction a ->
      staticRes ((FormUpdate.update >> updateCourse >> updateEditor) a screen)

    Save try ->
      case (screen.track, screen.editor) of
        (Just track, Just editor) ->
          taskRes (updateEditor (\e -> { e | saving = True}) screen) (save try track.id editor)
        _ ->
          res screen none

    SaveResult try result ->
      case result of
        Ok track ->
          let
            newScreen = updateEditor (\e -> { e | saving = False }) screen
            effect = if try
              then Effects.map (\_ -> NoOp) (Utils.redirect (Route.PlayTrack track.id))
              else none
          in
            res newScreen effect
        Err _ ->
          res screen none -- TODO

    ConfirmPublish ->
      res (updateEditor (\e -> { e | confirmPublish = not e.confirmPublish }) screen) none

    Publish ->
      case (screen.track, screen.editor) of
        (Just track, Just editor) ->
          taskRes (updateEditor (\e -> { e | saving = True}) screen) (publish track.id editor)
        _ ->
          res screen none

    NoOp ->
      res screen none


updateEditor : (Editor -> Editor) -> Screen -> Screen
updateEditor update screen =
  let
    newEditor = Maybe.map update screen.editor
  in
    { screen | editor = newEditor }


updateCourse : (Course -> Course) -> Editor -> Editor
updateCourse update editor =
  { editor | course = update editor.course }

updateSpeedVariation : (Range -> Range) -> GustGenerator -> GustGenerator
updateSpeedVariation updateRange ({speedVariation} as gen) =
  { gen | speedVariation = updateRange speedVariation  }

updateOriginVariation : (Range -> Range) -> GustGenerator -> GustGenerator
updateOriginVariation updateRange ({originVariation} as gen) =
  { gen | originVariation = updateRange originVariation  }

updateRangeStart start range =
  { range | start = start }

updateRangeEnd end range =
  { range | end = end }

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


staticRes m = res m none
