module Page.EditTrack.GridUpdate where

import Drag exposing (mouseEvents, MouseEvent(..))

import Constants exposing (sidebarWidth, hexRadius)
import Model.Shared exposing (..)
import CoreExtra exposing (..)

import Page.EditTrack.Model exposing (..)
import Hexagons
import Hexagons.Grid as Grid


mouseAction : MouseEvent -> Dims -> Editor -> Editor
mouseAction event dims editor =
  let
    courseDims = getCourseDims dims
  in
    case realMode editor of
      CreateTile kind ->
        updateTileAction kind event courseDims editor
      Erase ->
        deleteTileAction event courseDims editor
      Watch ->
        updateCenter event courseDims editor


deleteTileAction : MouseEvent -> Dims -> Editor -> Editor
deleteTileAction event courseDims editor =
  let
    coordsList = getMouseEventTiles editor courseDims event
    newGrid = List.foldl Grid.delete editor.course.grid coordsList
  in
    withGrid newGrid editor


updateTileAction : TileKind -> MouseEvent -> Dims -> Editor -> Editor
updateTileAction kind event courseDims editor =
  let
    coordsList = getMouseEventTiles editor courseDims event
    newGrid = List.foldl (Grid.set kind) editor.course.grid coordsList
  in
    withGrid newGrid editor


withGrid : Grid -> Editor -> Editor
withGrid grid ({course} as editor) =
  let
    newCourse = { course | grid = grid }
  in
    { editor | course = newCourse }


getMouseEventTiles : Editor -> Dims -> MouseEvent -> List Coords
getMouseEventTiles editor courseDims event =
  let
    tileCoords = (clickPoint editor courseDims) >> (Maybe.map (Hexagons.pointToAxial hexRadius))
  in
    case event of
      StartAt p ->
        case tileCoords p of
          Just c -> [ c ]
          Nothing -> [ ]
      MoveFromTo p1 p2 ->
        case (tileCoords p1, tileCoords p2) of
          (Just c1, Just c2) ->
            if c1 == c2 then [ c1 ] else Hexagons.axialLine c1 c2
          _ ->
            [ ]
      EndAt _ ->
        [ ]


clickPoint : Editor -> Dims -> (Int, Int) -> Maybe Point
clickPoint {center} courseDims (x, y) =
  if withinWindow courseDims (x, y) then
    let
      (w, h) = courseDims
      (cx, cy) = center
      x' = toFloat (x - sidebarWidth) - cx - toFloat w / 2
      y' = toFloat -y - cy + toFloat h / 2
    in
      Just (x', y')
  else
    Nothing


updateCenter : MouseEvent -> Dims -> Editor -> Editor
updateCenter event courseDims ({center} as editor) =
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
    { editor | center = newCenter }


withinWindow : Dims -> (Int, Int) -> Bool
withinWindow (w, h) (x, y) =
  let
    xWindow = (sidebarWidth, w + sidebarWidth)
    yWindow = (0, y)
  in
    within xWindow x && within yWindow y
