module Page.ShowTrack.Update where

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Effects exposing (Effects, Never, none)
import DragAndDrop exposing (mouseEvents, MouseEvent(..))
import Response exposing (..)

import Model.Shared exposing (..)
import Model exposing (..)
import Page.ShowTrack.Model exposing (..)
import ServerApi
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr ShowTrackAction

mount : String -> Response Model Action
mount slug =
  taskRes initial (loadLiveTrack slug)

mouseAction : MouseEvent -> Action
mouseAction =
  MouseAction

update : Action -> Model -> Response Model Action
update action ({courseControl} as model) =
  case action of

    LiveTrackResult result ->
      case result of
        Ok liveTrack ->
          res { model | liveTrack = Just liveTrack } none
        Err _ ->
          res { model | notFound = True } none

    SetOverCourse b ->
      res { model | courseControl = { courseControl | over = b } } none

    MouseAction event ->
      let
        dragging = case event of
          StartAt _ -> courseControl.over
          MoveFromTo _ _ -> courseControl.dragging
          EndAt _ -> False

        (dx, dy) = case event of
          StartAt _ ->
            (0, 0)
          MoveFromTo (xa, ya) (xb, yb) ->
            if courseControl.dragging then
              (toFloat (xb - xa) / courseControl.scale, toFloat (ya - yb) / courseControl.scale)
            else
              (0, 0)
          EndAt _ ->
            (0, 0)

        (x, y) = courseControl.center
        newCenter = (x + dx, y + dy)
        newControl = { courseControl | center = newCenter, dragging = dragging }
      in
        res { model | courseControl = newControl } none

    NoOp ->
      res model none


loadLiveTrack : TrackId -> Task Never Action
loadLiveTrack id =
  ServerApi.getLiveTrack id
    |> Task.map LiveTrackResult
