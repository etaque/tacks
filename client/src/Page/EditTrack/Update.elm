module Page.EditTrack.Update (..) where

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Dict
import Effects exposing (Effects, Never, none)
import Task.Extra exposing (delay)
import Keyboard
import Array
import Response exposing (..)
import Drag exposing (MouseEvent)
import Model
import Model.Shared exposing (..)
import Page.EditTrack.Model exposing (..)
import Page.EditTrack.FormUpdate as FormUpdate
import Page.EditTrack.GridUpdate as GridUpdate
import Constants exposing (..)
import ServerApi
import Update.Utils as Utils
import Route
import Hexagons


addr : Signal.Address Action
addr =
  Utils.pageAddr Model.EditTrackAction


inputs : Signal Action
inputs =
  Signal.mergeMany
    [ Signal.map AltMoveMode Keyboard.shift
    ]


mouseAction : MouseEvent -> Action
mouseAction =
  MouseAction


mount : String -> ( Model, Effects Action )
mount id =
  taskRes initial (loadTrack id)


update : Dims -> Action -> Model -> ( Model, Effects Action )
update dims action model =
  case action of
    LoadTrack result ->
      case result of
        Ok track ->
          staticRes { model | track = Just track, editor = Just (initialEditor track) }

        Err _ ->
          staticRes { model | notFound = True }

    ToggleBlock b ->
      staticRes ((updateBlocks >> updateEditor) b model)

    SetName n ->
      staticRes (updateEditor (\e -> { e | name = n }) model)

    MouseAction event ->
      staticRes (updateEditor (GridUpdate.mouseAction event dims) model)

    HoverToolbar isOver ->
      res (updateEditor (\e -> { e | hoverToolbar = isOver }) model) none

    SetMode mode ->
      staticRes (updateEditor (\e -> { e | mode = mode }) model)

    AltMoveMode b ->
      staticRes (updateEditor (\e -> { e | altMove = b }) model)

    FormAction a ->
      staticRes ((FormUpdate.update >> updateCourse >> updateEditor) a model)

    Save try ->
      case ( model.track, model.editor ) of
        ( Just track, Just editor ) ->
          taskRes (updateEditor (\e -> { e | saving = True }) model) (save try track.id editor)

        _ ->
          res model none

    SaveResult try result ->
      case result of
        Ok track ->
          let
            newModel =
              updateEditor (\e -> { e | saving = False }) model

            effect =
              if try then
                Effects.map (\_ -> NoOp) (Utils.redirect (Route.PlayTrack track.id))
              else
                none
          in
            res newModel effect

        Err _ ->
          res model none

    -- TODO
    ConfirmPublish ->
      res (updateEditor (\e -> { e | confirmPublish = not e.confirmPublish }) model) none

    Publish ->
      case ( model.track, model.editor ) of
        ( Just track, Just editor ) ->
          taskRes (updateEditor (\e -> { e | saving = True }) model) (publish track.id editor)

        _ ->
          res model none

    NoOp ->
      res model none


updateEditor : (Editor -> Editor) -> Model -> Model
updateEditor update model =
  let
    newEditor =
      Maybe.map update model.editor
  in
    { model | editor = newEditor }


updateCourse : (Course -> Course) -> Editor -> Editor
updateCourse update editor =
  { editor | course = update editor.course }


updateSpeedVariation : (Range -> Range) -> GustGenerator -> GustGenerator
updateSpeedVariation updateRange ({ speedVariation } as gen) =
  { gen | speedVariation = updateRange speedVariation }


updateOriginVariation : (Range -> Range) -> GustGenerator -> GustGenerator
updateOriginVariation updateRange ({ originVariation } as gen) =
  { gen | originVariation = updateRange originVariation }


updateRangeStart start range =
  { range | start = start }


updateRangeEnd end range =
  { range | end = end }


updateBlocks : SideBlock -> Editor -> Editor
updateBlocks b ({ blocks } as editor) =
  let
    newBlocks =
      case b of
        Name ->
          { blocks | name = not blocks.name }

        Surface ->
          { blocks | surface = not blocks.surface }

        Gates ->
          { blocks | gates = not blocks.gates }

        Wind ->
          { blocks | wind = not blocks.wind }

        Gusts ->
          { blocks | gusts = not blocks.gusts }
  in
    { editor | blocks = newBlocks }


loadTrack : String -> Task Never Action
loadTrack id =
  ServerApi.getTrack id
    |> Task.map LoadTrack


saveEditor : String -> Editor -> Task Never (FormResult Track)
saveEditor id ({ course, name } as editor) =
  ServerApi.saveTrack id name { course | area = getRaceArea course.grid }


save : Bool -> String -> Editor -> Task Never Action
save try id editor =
  delay 500 (saveEditor id editor)
    |> Task.map (SaveResult try)


publish : String -> Editor -> Task Never Action
publish id ({ course, name } as editor) =
  delay 500 (saveEditor id editor)
    `andThen` (\_ -> ServerApi.publishTrack id)
    |> Task.map (SaveResult True)


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


staticRes m =
  res m none
