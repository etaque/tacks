module Screens.ShowTrack.Updates where

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Effects exposing (Effects, Never, none)
import DragAndDrop exposing (mouseEvents, MouseEvent(..))

import Models exposing (..)
import AppTypes exposing (..)
import Screens.ShowTrack.Types exposing (..)
import ServerApi
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr ShowTrackAction

mount : String -> (Screen, Effects Action)
mount slug =
  initial &! (loadLiveTrack slug)

mouseAction : MouseEvent -> Action
mouseAction =
  MouseAction

update : Action -> Screen -> (Screen, Effects Action)
update action ({courseControl} as screen) =
  case action of

    LiveTrackResult result ->
      case result of
        Ok liveTrack ->
          { screen | liveTrack = Just liveTrack } &: none
        Err _ ->
          { screen | notFound = True } &: none

    SetOverCourse b ->
      { screen | courseControl = { courseControl | over = b } } &: none

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
        { screen | courseControl = newControl } &: none

    NoOp ->
      screen &: none


loadLiveTrack : TrackId -> Task Never Action
loadLiveTrack id =
  ServerApi.getLiveTrack id
    |> Task.map LiveTrackResult
