module View.HexBg exposing (..)

import Dict exposing (Dict)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Hexagons
import Constants
import Model.Shared exposing (..)
import Game.Render.Tiles as RenderTiles exposing (lazyRenderTiles)


type alias Pixel =
    Int


type alias Axial =
    Int


render : Dims -> Svg msg
render ( w, h ) =
    svg
        [ width (toString w)
        , height (toString h)
        , class "hex-bg"
        ]
        [ lazyRenderTiles (buildGrid ( w, h )) ]


buildGrid : Dims -> Grid
buildGrid dims =
    buildGridRec dims 0 []
        |> List.map (\c -> ( c, Water ))
        |> Dict.fromList


buildGridRec : Dims -> Axial -> List Coords -> List Coords
buildGridRec ( w, h ) j grid =
    if getPixelY (j - 1) > toFloat h then
        grid
    else
        buildGridRec ( w, h ) (j + 1) (grid ++ (buildRow j w))


buildRow : Axial -> Pixel -> List Coords
buildRow j w =
    let
        y =
            getPixelY j

        ( from, _ ) =
            Hexagons.pointToAxial Constants.hexRadius ( 0, y )

        ( to, _ ) =
            Hexagons.pointToAxial Constants.hexRadius ( toFloat w, y )
    in
        List.map (\i -> ( i, j )) [from..to]


getPixelY : Int -> Float
getPixelY j =
    Hexagons.axialToPoint Constants.hexRadius ( 0, j )
        |> snd
