
module Screens.EditTrack.FormUpdates where

import Models exposing (..)
import Screens.EditTrack.Types exposing (..)


update : FormUpdate -> Course -> Course
update fu course =
  case fu of

    SetUpwindY y ->
      updateUpwindY y course

    SetDownwindY y ->
      updateDownwindY y course

    SetGateWidth w ->
      updateGateWidth w course

    SetLaps laps ->
      { course | laps <- laps }


updateUpwindY : Int -> Course -> Course
updateUpwindY y ({upwind} as course) =
  let
    newUpwind = { upwind | y <- toFloat y }
  in
    { course | upwind <- newUpwind }


updateDownwindY : Int -> Course -> Course
updateDownwindY y ({downwind} as course) =
  let
    newDownwind = { downwind | y <- toFloat y }
  in
    { course | downwind <- newDownwind }


updateGateWidth : Int -> Course -> Course
updateGateWidth w ({upwind, downwind} as course) =
  let
    newDownwind = { downwind | width <- toFloat w }
    newUpwind = { upwind | width <- toFloat w }
  in
    { course | downwind <- newDownwind, upwind <- newUpwind }

