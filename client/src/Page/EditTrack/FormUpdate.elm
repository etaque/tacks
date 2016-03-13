module Page.EditTrack.FormUpdate (..) where

import String
import Result
import CoreExtra
import Model.Shared exposing (..)
import Game.Models exposing (defaultGate)
import Page.EditTrack.Model exposing (..)


update : FormUpdate -> Course -> Course
update fu ({ start, gates } as course) =
  case fu of
    SetStartCenterX x ->
      { course | start = { start | center = ( toFloat x, snd start.center ) } }

    SetStartCenterY y ->
      { course | start = { start | center = ( fst start.center, toFloat y ) } }

    SetStartWidth w ->
      { course | start = { start | width = toFloat w } }

    SetStartOrientation o ->
      { course | start = { start | orientation = o } }

    AddGate ->
      { course | gates = gates ++ [ defaultGate ] }

    SetGateCenterX i x ->
      { course | gates = CoreExtra.updateAt i (\g -> { g | center = ( toFloat x, snd g.center ) }) gates }

    SetGateCenterY i y ->
      { course | gates = CoreExtra.updateAt i (\g -> { g | center = ( fst g.center, toFloat y ) }) gates }

    SetGateWidth i w ->
      { course | gates = CoreExtra.updateAt i (\g -> { g | width = toFloat w }) gates }

    SetGateOrientation i o ->
      { course | gates = CoreExtra.updateAt i (\g -> { g | orientation = o }) gates }

    RemoveGate i ->
      { course | gates = CoreExtra.removeAt i gates }

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


updateGustGen : (GustGenerator -> GustGenerator) -> Course -> Course
updateGustGen update course =
  { course | gustGenerator = update course.gustGenerator }


updateWindGen : (WindGenerator -> WindGenerator) -> Course -> Course
updateWindGen update course =
  { course | windGenerator = update course.windGenerator }
