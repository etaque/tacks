module Game.Grid where

import Game.Core as Core
import Models exposing (..)

import Dict exposing (Dict)


hexRadius = 50
hexHeight = hexRadius * 2
hexWidth = (sqrt 3) / 2 * hexHeight
hexDims = (hexWidth, hexHeight)

currentTile : Grid -> Point -> Maybe TileKind
currentTile grid p =
    pointToHexCoords p
      |> getTile grid

getTile : Grid -> Coords -> Maybe TileKind
getTile grid (i, j) =
  (Dict.get i grid) `Maybe.andThen` (Dict.get j)

createTile : TileKind -> Coords -> Grid -> Grid
createTile kind (i,j) grid =
  let
    updateRow : Maybe GridRow -> GridRow
    updateRow maybeRow =
      case maybeRow of
        Just row ->
          Dict.insert j kind row
        Nothing ->
          Dict.singleton j kind
  in
    Dict.insert i (updateRow (Dict.get i grid)) grid

deleteTile : Coords -> Grid -> Grid
deleteTile (i, j) grid =
  let
    deleteInRow maybeRow =
      case maybeRow of
        Just row ->
          Dict.remove j row
        Nothing ->
          Dict.empty
  in
    Dict.insert i (deleteInRow (Dict.get i grid)) grid


hexCoordsToPoint : Coords -> Point
hexCoordsToPoint (i, j) =
  let
    x = hexRadius * (sqrt 3) * (toFloat i + toFloat j / 2)
    y = hexRadius * 3 / 2 * toFloat j
  in
    (x, y)

pointToHexCoords : Point -> Coords
pointToHexCoords (x, y) =
  let
    i = (x * (sqrt 3) / 3 - y / 3) / hexRadius
    j = y * (2 / 3) / hexRadius
  in
    hexRound (i, j)

hexRound : (Float, Float) -> Coords
hexRound =
  hexToCube >> cubeRound >> cubeToHex

cubeRound : Cube Float -> Cube Int
cubeRound (x, y, z) =
  let
    rx = round x
    ry = round y
    rz = round z

    xDiff = abs (toFloat rx - x)
    yDiff = abs (toFloat ry - y)
    zDiff = abs (toFloat rz - z)
  in
    if | xDiff > yDiff && xDiff > zDiff -> (-ry-rz, ry, rz)
       | yDiff > zDiff                  -> (rx, -rx-rz, rz)
       | otherwise                      -> (rx, ry, -rx-ry)

cubeToHex : Cube number -> (number, number)
cubeToHex (x, y, z) =
  (x, y)

hexToCube : (number, number) -> Cube number
hexToCube (i, j) =
  (i, j, -i-j)

cubeDistance : Cube Int -> Cube Int -> Int
cubeDistance (ax, ay, az) (bx, by, bz) =
  (abs (ax - bx) + abs (ay - by) + abs (az - bz)) // 2

hexDistance : Coords -> Coords -> Int
hexDistance a b =
  cubeDistance (hexToCube a) (hexToCube b)

cubeLinearInterpol : Cube Int -> Cube Int -> Float -> Cube Float
cubeLinearInterpol a b t =
  let
    (ax, ay, az) = floatCube a
    (bx, by, bz) = floatCube b
    i = ax + (bx - ax) * t
    j = ay + (by - ay) * t
    k = az + (bz - az) * t
  in
    (i, j, k)

floatCube : Cube Int -> Cube Float
floatCube (x, y, z) =
  (toFloat x, toFloat y, toFloat z)

cubeLine : Cube Int -> Cube Int -> List (Cube Int)
cubeLine a b =
  let
    n = cubeDistance a b
    offsetMapper i = cubeRound (cubeLinearInterpol a b (1 / (toFloat n) * (toFloat i)))
  in
    List.map offsetMapper [ 0..n ]

-- See http://www.redblobgames.com/grids/hexagons/#range
hexRange : Coords -> Int -> List Coords
hexRange center n =
  let
    mapX dx =
      let
        fromY = max -n (-dx - n)
        toY = min n (-dx + n)
        mapY dy = hexAdd center (dx, dy)
      in
        List.map mapY [ fromY .. toY ]
  in
    List.concatMap mapX [ -n .. n ]

hexAdd : Coords -> Coords -> Coords
hexAdd (x, y) (x', y') =
  (x + x', y + y')

cubeAdd : Cube Int -> Cube Int -> Cube Int
cubeAdd (x, y, z) (i, j, k) =
  (x + i, y + j, z + k)

hexLine : Coords -> Coords -> List Coords
hexLine a b =
  List.map cubeToHex (cubeLine (hexToCube a) (hexToCube b))

getTilesList : Grid -> List Tile
getTilesList grid =
  let
    rows : List (Int, GridRow)
    rows =
      Dict.toList grid

    mapRow : (Int, GridRow) -> List Tile
    mapRow (i, row) =
      List.map (mapTile i) (Dict.toList row)

    mapTile : Int -> (Int, TileKind) -> Tile
    mapTile i (j, kind) =
      Tile kind (i, j)
  in
    List.concatMap mapRow rows

