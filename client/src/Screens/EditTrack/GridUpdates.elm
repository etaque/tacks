module Screens.EditTrack.GridUpdates where

import DragAndDrop exposing (mouseEvents, MouseEvent(..))

import Constants exposing (sidebarWidth)
import Models exposing (..)
import Game.Grid exposing (..)

import Screens.EditTrack.Types exposing (..)


mouseAction : MouseEvent -> Editor -> Editor
mouseAction event editor =
  case editor.mode of
    CreateTile kind ->
      updateTileAction kind event editor
    Erase ->
      deleteTileAction event editor
    Watch ->
      updateCenter event editor


deleteTileAction : MouseEvent -> Editor -> Editor
deleteTileAction event editor =
  let
    coordsList = getMouseEventTiles editor event
    newGrid = List.foldl deleteTile editor.course.grid coordsList
  in
    withGrid newGrid editor

updateTileAction : TileKind -> MouseEvent -> Editor -> Editor
updateTileAction kind event editor =
  let
    coordsList = getMouseEventTiles editor event
    newGrid = List.foldl (createTile kind) editor.course.grid coordsList
  in
    withGrid newGrid editor

withGrid : Grid -> Editor -> Editor
withGrid grid ({course} as editor) =
  let
    newCourse = { course | grid <- grid }
  in
    { editor | course <- newCourse }

getMouseEventTiles : Editor -> MouseEvent -> List Coords
getMouseEventTiles editor event =
  let
    tileCoords = (clickPoint editor) >> pointToHexCoords
  in
    case event of
      StartAt p ->
        [ tileCoords p ]
      MoveFromTo p1 p2 ->
        let
          c1 = tileCoords p1
          c2 = tileCoords p2
        in
          if c1 == c2 then [ c1 ] else hexLine c1 c2
      EndAt _ ->
        [ ]

clickPoint : Editor -> (Int, Int) -> Point
clickPoint {courseDims, center} (x, y) =
  let
    (w, h) = courseDims
    (cx, cy) = center
    x' = toFloat (x - sidebarWidth) - cx - toFloat w / 2
    y' = toFloat -y - cy + toFloat h / 2
  in
    (x', y')

updateCenter : MouseEvent -> Editor -> Editor
updateCenter event ({center} as editor) =
  let
    (dx, dy) =
      case event of
        StartAt _ ->
          (0, 0)
        MoveFromTo (xa, ya) (xb, yb) ->
          (xb - xa, ya - yb)
        EndAt _ ->
          (0, 0)
    newCenter = (fst center + toFloat dx, snd center + toFloat dy)
  in
    { editor | center <- newCenter }

