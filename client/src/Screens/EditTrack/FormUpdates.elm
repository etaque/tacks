module Screens.EditTrack.FormUpdates where

import Models exposing (..)
import Screens.EditTrack.Types exposing (..)

import Array


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

    SetGustInterval i ->
      updateGustGen (\gen -> { gen | interval <- i }) course

    SetGustAngle i angle ->
      (updateGustGen << updateGustDefs) (updateAt i (\def -> { def | angle <- toFloat angle })) course

    SetGustSpeed i speed ->
      (updateGustGen << updateGustDefs) (updateAt i (\def -> { def | speed <- toFloat speed })) course

    SetGustRadius i radius ->
      (updateGustGen << updateGustDefs) (updateAt i (\def -> { def | radius <- toFloat radius })) course

    CreateGustDef ->
      (updateGustGen << updateGustDefs) (\defs -> GustDef 0 0 200 :: defs) course

    RemoveGustDef i ->
      (updateGustGen << updateGustDefs) (removeAt i) course

    SetWindW1 i ->
      updateWindGen (\g -> { g | wavelength1 <- i }) course

    SetWindA1 i ->
      updateWindGen (\g -> { g | amplitude1 <- i }) course

    SetWindW2 i ->
      updateWindGen (\g -> { g | wavelength2 <- i }) course

    SetWindA2 i ->
      updateWindGen (\g -> { g | amplitude2 <- i }) course


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


updateGustDefs : (List GustDef -> List GustDef) -> GustGenerator -> GustGenerator
updateGustDefs update gen =
  { gen | defs <- update gen.defs }


updateGustGen : (GustGenerator -> GustGenerator) -> Course -> Course
updateGustGen update course =
  { course | gustGenerator <- update course.gustGenerator }


updateWindGen : (WindGenerator -> WindGenerator) -> Course -> Course
updateWindGen update course =
  { course | windGenerator <- update course.windGenerator }


removeAt : Int -> List a -> List a
removeAt i items =
  (List.take i items) ++ (List.drop (i + 1) items)


updateAt : Int -> (a -> a) -> List a -> List a
updateAt i update items =
  let
    asArray = Array.fromList items
  in
    case Array.get i asArray of
      Just item ->
        asArray
          |> Array.set i (update item)
          |> Array.toList
      Nothing ->
        items

