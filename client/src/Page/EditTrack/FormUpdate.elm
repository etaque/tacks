module Page.EditTrack.FormUpdate (..) where

import CoreExtra
import Game.Models exposing (defaultGate)
import Page.EditTrack.Model exposing (..)


update : FormUpdate -> Editor -> Editor
update formUpdate ({ course } as editor) =
  let
    { start, gates, windGenerator } =
      course

    updateGate i f =
      if i == 0 then
        { course | start = f start }
      else
        { course | gates = CoreExtra.updateAt (i - 1) f gates }

    updateEditorGates newCurrentGate newCourse =
      { editor | course = newCourse, currentGate = newCurrentGate }

    updateWindGen g =
      { editor | course = { course | windGenerator = g } }
  in
    case formUpdate of
      AddGate ->
        updateEditorGates
          (Just (List.length gates + 1))
          { course | gates = gates ++ [ defaultGate ] }

      SetGateCenterX i x ->
        updateEditorGates
          (Just i)
          (updateGate i (\g -> { g | center = ( toFloat x, snd g.center ) }))

      SetGateCenterY i y ->
        updateEditorGates
          (Just i)
          (updateGate i (\g -> { g | center = ( fst g.center, toFloat y ) }))

      SetGateWidth i w ->
        updateEditorGates
          (Just i)
          (updateGate i (\g -> { g | width = toFloat w }))

      SetGateOrientation i o ->
        updateEditorGates
          (Just i)
          (updateGate i (\g -> { g | orientation = o }))

      RemoveGate i ->
        updateEditorGates
          Nothing
          { course | gates = CoreExtra.removeAt (i - 1) gates }

      UpdateGustGen fn ->
        { editor | course = { course | gustGenerator = fn course.gustGenerator } }

      SetWindSpeed s ->
        { editor | course = { course | windSpeed = s } }

      SetWindW1 i ->
        updateWindGen { windGenerator | wavelength1 = i }

      SetWindA1 i ->
        updateWindGen { windGenerator | amplitude1 = i }

      SetWindW2 i ->
        updateWindGen { windGenerator | wavelength2 = i }

      SetWindA2 i ->
        updateWindGen { windGenerator | amplitude2 = i }
