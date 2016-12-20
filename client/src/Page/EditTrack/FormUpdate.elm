module Page.EditTrack.FormUpdate exposing (..)

import List.Extra as List
import Model.Shared exposing (..)
import Game.Utils as Utils
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
                { course | gates = List.updateAt (i - 1) f gates |> Maybe.withDefault gates }

        updateEditorGates i newCourse =
            { editor
                | course = newCourse
                , currentGate = Just i
                , center =
                    List.getAt i (newCourse.start :: newCourse.gates)
                        |> Maybe.map (.center >> Utils.neg)
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
                updateEditorGates i (updateGate i (\g -> { g | center = ( toFloat x, Tuple.second g.center ) }))

            SetGateCenterY i y ->
                updateEditorGates i (updateGate i (\g -> { g | center = ( Tuple.first g.center, toFloat y ) }))

            SetGateWidth i w ->
                updateEditorGates i (updateGate i (\g -> { g | width = toFloat w }))

            SetGateOrientation i o ->
                updateEditorGates i (updateGate i (\g -> { g | orientation = o }))

            RemoveGate i ->
                updateEditorGates (i - 1) { course | gates = List.removeAt (i - 1) gates }

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


defaultGate : Gate
defaultGate =
    { label = Nothing
    , center = ( 0, 0 )
    , width = 100
    , orientation = North
    }
