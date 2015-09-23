module Screens.EditTrack.Updates where

import Task exposing (Task, succeed, map, andThen)
import Task.Extra exposing (delay)
import Time exposing (second)
import Http
import Keyboard
import Array
import Result
import String

import DragAndDrop exposing (mouseEvents, MouseEvent(..))

import Constants exposing (sidebarWidth)
import AppTypes exposing (local, react, request, Never)
import Models exposing (..)

import Screens.EditTrack.Types exposing (..)

import Game.Grid exposing (..)
import ServerApi

import Debug

actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp

inputs : Signal Action
inputs =
  Signal.mergeMany
    [ Signal.map (\b -> if b then NextTileKind else NoOp) Keyboard.space
    , Signal.map (\b -> if b then EscapeMode else NoOp) (Keyboard.isDown 27)
    , Signal.map MouseAction mouseEvents
    ]

type alias Update = AppTypes.ScreenUpdate Screen


mount : Dims -> String -> Update
mount dims slug =
  let
    initial =
      { track = Nothing
      , editor = Nothing
      , notFound = False
      , dims = dims
      }
  in
    react initial (loadTrack slug)


update : Action -> Screen -> Update
update action screen =
  case action of

    SetTrack track ->
      let
        editor =
          { course = track.course
          , center = (0, 0)
          , courseDims = getCourseDims screen.dims
          , mode = CreateTile Water
          }
      in
        local { screen | track <- Just track, editor <- Just editor }

    TrackNotFound ->
      local { screen | notFound <- True }

    MouseAction event ->
      screen
        |> updateEditor (mouseAction event)
        |> local

    NextTileKind ->
      screen
        |> updateEditor (\e -> { e | mode <- getNextMode e.mode })
        |> local

    EscapeMode ->
      screen
        |> updateEditor (\e -> { e | mode <- Watch })
        |> local

    SetUpwindY y ->
      screen
        |> (updateUpwindY >> updateCourse >> updateEditor ) y
        |> Debug.log "upwindy"
        |> local

    SetDownwindY y ->
      screen
        |> (updateDownwindY >> updateCourse >> updateEditor ) y
        |> local

    SetGateWidth w ->
      screen
        |> (updateGateWidth >> updateCourse >> updateEditor) w
        |> local

    SetLaps laps ->
      screen
        |> (updateLaps >> updateCourse >> updateEditor ) laps
        |> local

    Save ->
      case (screen.track, screen.editor) of
        (Just track, Just editor) ->
          react screen (save track.slug editor)
        _ ->
          local screen

    _ ->
      local screen


updateEditor : (Editor -> Editor) -> Screen -> Screen
updateEditor update screen =
  let
    newEditor = Maybe.map update screen.editor
  in
    { screen | editor <- newEditor }

updateCourse : (Course -> Course) -> Editor -> Editor
updateCourse update editor =
  { editor | course <- update editor.course }

loadTrack : String -> Task Never ()
loadTrack slug =
  ServerApi.getTrack slug `andThen`
    \result ->
      case result of
        Ok track ->
          Signal.send actions.address (SetTrack track)
        Err _ ->
          Task.succeed ()


updateDims : Dims -> Screen -> Screen
updateDims dims screen =
  let
    newEditor = Maybe.map (\e -> { e | courseDims <- getCourseDims dims } ) screen.editor
  in
    { screen | editor <- newEditor, dims <- dims }

getCourseDims : Dims -> Dims
getCourseDims (w, h) =
  (w - sidebarWidth, h)

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

getNextMode : Mode -> Mode
getNextMode mode =
  case mode of
    CreateTile Water ->
      CreateTile Grass
    CreateTile Grass ->
      CreateTile Rock
    CreateTile Rock ->
      Erase
    _ ->
      CreateTile Water

updateUpwindY : Int -> Course -> Course
updateUpwindY y ({upwind} as course) =
  let
    newUpwind = { upwind | y <- toFloat y }
  in
    { course | upwind <- newUpwind }

updateDownwindY : Int -> Course -> Course
updateDownwindY y ({downwind} as course) =
  let
    newDownwind = { downwind | y <- toFloat y }
  in
    { course | downwind <- newDownwind }

updateGateWidth : Int -> Course -> Course
updateGateWidth w ({upwind, downwind} as course) =
  let
    newDownwind = { downwind | width <- toFloat w }
    newUpwind = { upwind | width <- toFloat w }
  in
    { course | downwind <- newDownwind, upwind <- newUpwind }


updateLaps : Int -> Course -> Course
updateLaps laps course =
  { course | laps <- laps }

save : String -> Editor -> Task Never ()
save slug ({course} as editor) =
  let
    area = getRaceArea course.grid
    withArea = { course | area <- area }
  in
    ServerApi.saveTrack slug withArea `andThen`
      \result -> Task.succeed ()

getRaceArea : Grid -> RaceArea
getRaceArea grid =
  let
    waterPoints = getTilesList grid
      |> List.filter (\t -> t.kind == Water)
      |> List.map (\t -> hexCoordsToPoint t.coords)

    xVals = waterPoints
      |> List.map fst
      |> List.sort
      |> Array.fromList

    yVals = waterPoints
      |> List.map snd
      |> List.sort
      |> Array.fromList

    getFirst arr = Maybe.withDefault 0 (Array.get 0 arr)
    getLast arr = Maybe.withDefault 0 (Array.get (Array.length arr - 1) arr)

    right = getLast xVals
    left = getFirst xVals

    top = getLast yVals
    bottom = getFirst yVals
  in
    RaceArea (right, top) (left, bottom)
