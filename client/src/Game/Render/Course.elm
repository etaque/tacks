module Game.Render.Course exposing (..)

import Constants
import Game.Shared exposing (..)
import Model.Shared exposing (..)
import Hexagons
import Game.Render.Gates as Gates
import Game.Render.Tiles as Tiles
import Game.Render.Layer as Layer
import Dict
import Html exposing (Html)
import Svg exposing (..)
import Svg.Keyed
import Svg.Attributes exposing (..)


render : GameState -> Svg msg
render ({ playerState, course, gusts, timers, wind } as gameState) =
    g
        [ class "course" ]
        [ renderTiledGusts gusts
        , renderGates playerState course timers.localTime (isStarted gameState)
        ]



-- gatesLayer : GameState -> Html msg
-- gatesLayer gameState =


courseGridLayer : ( Int, Int ) -> GameState -> Html msg
courseGridLayer dims gameState =
    let
        { rightTop, leftBottom } =
            gameState.course.area

        ( ( right, top ), ( left, bottom ) ) =
            ( rightTop, leftBottom )
    in
        LayerDef.svgLayer
            { size = dims
            , center = gameState.center
            }
            { width = right - left + 2 * Constants.hexRadius
            , height = top - bottom + 2 * Constants.hexRadius
            , left = left - Constants.hexRadius
            , bottom = bottom - Constants.hexRadius
            , rotation = 0
            }
            "course-layer"
            (Tiles.lazyRenderTiles gameState.course.grid)


renderTiledGusts : TiledGusts -> Svg msg
renderTiledGusts { gusts } =
    Svg.Keyed.node "g" [ class "tiled-gusts" ] (List.map renderTiledGust gusts)


renderTiledGust : TiledGust -> ( String, Svg msg )
renderTiledGust { id, tiles } =
    let
        node =
            tiles
                |> Dict.toList
                |> List.map renderGustTile
                |> g [ class "tiled-gust" ]
    in
        ( id, node )


renderGustTile : ( Coords, GustTile ) -> Svg msg
renderGustTile ( coords, { angle, speed } ) =
    let
        ( x, y ) =
            Hexagons.axialToPoint Constants.hexRadius coords

        a =
            0.3 * (abs speed) / 10

        color =
            if speed > 0 then
                "black"
            else
                "white"
    in
        polygon
            [ points Tiles.verticesPoints
            , fill color
            , opacity (toString a)
            , transform ("translate(" ++ toString x ++ ", " ++ toString y ++ ")")
            ]
            []


renderGates : PlayerState -> Course -> Float -> Bool -> Svg msg
renderGates { crossedGates } { start, gates } time started =
    start
        :: gates
        |> List.indexedMap (\i g -> Gates.render time started (i - List.length crossedGates) g)
        |> List.filterMap identity
        |> g [ class "gates" ]
