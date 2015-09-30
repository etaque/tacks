module Screens.EditTrack.GridUpdates where

import DragAndDrop exposing (mouseEvents, MouseEvent(..))

import Constants exposing (sidebarWidth)
import Models exposing (..)
import CoreExtra exposing (..)
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
    tileCoords = (clickPoint editor) >> (Maybe.map pointToHexCoords)
  in
    case event of
      StartAt p ->
        case tileCoords p of
          Just c -> [ c ]
          Nothing -> [ ]
      MoveFromTo p1 p2 ->
        case (tileCoords p1, tileCoords p2) of
          (Just c1, Just c2) ->
            if c1 == c2 then [ c1 ] else hexLine c1 c2
          _ ->
            [ ]
      EndAt _ ->
        [ ]


clickPoint : Editor -> (Int, Int) -> Maybe Point
clickPoint {courseDims, center} (x, y) =
  if withinWindow courseDims (x, y) then
    let
      (cx, cy) = center
      x' = toFloat (x - sidebarWidth) - cx - toFloat w / 2
      y' = toFloat -y - cy + toFloat h / 2
    in
      Just (x', y')
  else
    Nothing


updateCenter : MouseEvent -> Editor -> Editor
updateCenter event ({courseDims, center} as editor) =
  let
    (dx, dy) =
      case event of
        StartAt _ ->
          (0, 0)
        MoveFromTo (xa, ya) (xb, yb) ->
          if withinWindow courseDims (xa, ya) && withinWindow courseDims (xb, yb) then
            (xb - xa, ya - yb)
          else
            (0, 0)
        EndAt _ ->
          (0, 0)
    newCenter = (fst center + toFloat dx, snd center + toFloat dy)
  in
    { editor | center <- newCenter }


withinWindow : Dims -> (Int, Int) -> Bool
withinWindow (w, h) (x, y) =
  let
    xWindow = (sidebarWidth, w + sidebarWidth)
    yWindow = (0, y)
  in
    within xWindow x && within yWindow y

