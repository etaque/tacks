module Page.EditTrack.FormUpdate exposing (..)

import CoreExtra
import Game.Models exposing (defaultGate)
import Game.Geo as Geo
import Page.EditTrack.Model exposing (..)


update : FormMsg -> Editor -> Editor
update formMsg ({ course } as editor) =
    let
        { start, gates, windGenerator } =
            course

        updateGate i f =
            if i == 0 then
                { course | start = f start }
            else
                { course | gates = CoreExtra.updateAt (i - 1) f gates }

        updateEditorGates i newCourse =
            { editor
                | course = newCourse
                , currentGate = Just i
                , center =
                    CoreExtra.getAt i (newCourse.start :: newCourse.gates)
                        |> Maybe.map (.center >> Geo.neg)
                        |> Maybe.withDefault editor.center
            }

        updateWindGen g =
            { editor | course = { course | windGenerator = g } }
    in
        case formMsg of
            SelectGate i ->
                updateEditorGates i course

            AddGate ->
                updateEditorGates (List.length gates + 1) { course | gates = gates ++ [ defaultGate ] }

            SetGateCenterX i x ->
                updateEditorGates i (updateGate i (\g -> { g | center = ( toFloat x, snd g.center ) }))

            SetGateCenterY i y ->
                updateEditorGates i (updateGate i (\g -> { g | center = ( fst g.center, toFloat y ) }))

            SetGateWidth i w ->
                updateEditorGates i (updateGate i (\g -> { g | width = toFloat w }))

            SetGateOrientation i o ->
                updateEditorGates i (updateGate i (\g -> { g | orientation = o }))

            RemoveGate i ->
                updateEditorGates (i - 1) { course | gates = CoreExtra.removeAt (i - 1) gates }

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

            SetWindSimDuration d ->
                { editor | windSimDuration = d }
