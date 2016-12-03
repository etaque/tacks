module Page.EditTrack.View exposing (..)

import Html exposing (Html)
import Html.Events exposing (on)
import Html.Lazy
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Json.Decode as Json
import Model.Shared exposing (..)
import Page.EditTrack.Model exposing (..)
import Page.EditTrack.View.Context as Context
import View.Layout as Layout
import View.HexBg as HexBg
import Game.Geo exposing (floatify)
import Game.Render.SvgUtils exposing (..)
import Game.Render.Gates as Gates
import Game.Render.Players as Players
import Game.Render.WebGL as GameWebGL
import Mouse


view : Context -> Model -> Layout.Game Msg
view ({ player, dims } as ctx) model =
    case ( model.track, model.editor ) of
        ( Just track, Just editor ) ->
            if canUpdateDraft player track then
                Layout.Game
                    "editor"
                    (Context.toolbar track editor)
                    (Context.view track editor)
                    (renderCourse dims editor)
            else
                Layout.Game
                    "editor forbidden"
                    [ text "Access forbidden." ]
                    []
                    []

        _ ->
            Layout.Game
                "editor loading"
                [ text "" ]
                []
                [ Html.Lazy.lazy HexBg.render ctx.dims ]


renderCourse : Dims -> Editor -> List (Html Msg)
renderCourse dims ({ center, course, mode } as editor) =
    let
        ( w, h ) =
            getCourseDims dims

        cx =
            toFloat w / 2 + Tuple.first center

        cy =
            toFloat -h / 2 + Tuple.second center

        viewport =
            GameWebGL.Viewport { width = w, height = h } 2 center

        renderGate i gate =
            if editor.currentGate == Just i then
                Gates.renderOpenGate 0 gate
            else
                Gates.renderClosedGate 0 gate
    in
        [ Svg.svg
            [ width (toString w)
            , height (toString h)
            , on "mousedown" (Json.map (DragStart >> MouseMsg) Mouse.position)
            , class <| "mode-" ++ (modeName (realMode editor) |> Tuple.first)
            ]
            [ g
                [ transform ("scale(1,-1)" ++ (translate cx cy)) ]
                [ g [] (List.indexedMap renderGate (course.start :: course.gates))
                , Players.renderPlayerHull 0 0
                ]
            ]
        , GameWebGL.renderGrid viewport course.grid
        ]
