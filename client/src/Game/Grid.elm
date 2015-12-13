module Game.Grid where

import Models exposing (..)

import Dict exposing (Dict)

import Hexagons


hexRadius = 50
hexHeight = hexRadius * 2
hexWidth = (sqrt 3) / 2 * hexHeight
hexDims = (hexWidth, hexHeight)

currentTile : Grid -> Point -> Maybe TileKind
currentTile grid p =
    Hexagons.pointToAxial hexRadius p
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

