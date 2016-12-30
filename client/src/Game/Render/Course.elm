module Game.Render.Course exposing (..)

import Constants
import Game.Shared exposing (..)
import Model.Shared exposing (..)
import Hexagons
import Game.Render.Gates as Gates
import Game.Render.Tiles as Tiles
import Dict
import Svg exposing (..)
import Svg.Keyed
import Svg.Attributes exposing (..)


renderCourse : GameState -> Svg msg
renderCourse ({ playerState, course, gusts, timers, wind } as gameState) =
    g
        [ class "course" ]
        [ Tiles.lazyRenderTiles course.grid
        , renderTiledGusts gusts
          -- , renderGusts wind
        , renderGates playerState course timers.localTime (isStarted gameState)
        ]


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
