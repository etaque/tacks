module Screens.EditTrack.FormUpdate where

import Models exposing (..)
import Screens.EditTrack.Model exposing (..)


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
      { course | laps = laps }

    UpdateGustGen fn ->
      updateGustGen fn course

    SetWindSpeed s ->
      { course | windSpeed = s }

    SetWindW1 i ->
      updateWindGen (\g -> { g | wavelength1 = i }) course

    SetWindA1 i ->
      updateWindGen (\g -> { g | amplitude1 = i }) course

    SetWindW2 i ->
      updateWindGen (\g -> { g | wavelength2 = i }) course

    SetWindA2 i ->
      updateWindGen (\g -> { g | amplitude2 = i }) course


updateUpwindY : Int -> Course -> Course
updateUpwindY y ({upwind} as course) =
  { course | upwind = { upwind | y = toFloat y } }


updateDownwindY : Int -> Course -> Course
updateDownwindY y ({downwind} as course) =
  { course | downwind = { downwind | y = toFloat y } }


updateGateWidth : Int -> Course -> Course
updateGateWidth w ({upwind, downwind} as course) =
  let
    newDownwind = { downwind | width = toFloat w }
    newUpwind = { upwind | width = toFloat w }
  in
    { course | downwind = newDownwind, upwind = newUpwind }


updateGustGen : (GustGenerator -> GustGenerator) -> Course -> Course
updateGustGen update course =
  { course | gustGenerator = update course.gustGenerator }


updateWindGen : (WindGenerator -> WindGenerator) -> Course -> Course
updateWindGen update course =
  { course | windGenerator = update course.windGenerator }
