module Screens.EditTrack.Updates where

import Task exposing (Task, succeed, map, andThen)
import Task.Extra exposing (delay)
import Time exposing (second)
import Http
import Keyboard
import DragAndDrop exposing (mouseEvents, MouseEvent(..))

import Constants exposing (sidebarWidth)
import AppTypes exposing (local, react, request, Never)
import Models exposing (..)
import Screens.EditTrack.Types exposing (..)
import Game.Grid exposing (..)
import ServerApi


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


mount : (Int, Int) -> String -> Update
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
          { grid = track.course.grid
          , upwind = track.course.upwind
          , downwind = track.course.downwind
          , center = (0, 0)
          , dims = screen.dims
          , mode = CreateTile Water
          }
      in
        local { screen | track <- Just track, editor <- Just editor }

    TrackNotFound ->
      local { screen | notFound <- True }

    MouseAction event ->
      updateEditor (mouseAction event) screen
        |> local

    NextTileKind ->
      updateEditor (\e -> { e | mode <- getNextMode e.mode }) screen
        |> local

    EscapeMode ->
      updateEditor (\e -> { e | mode <- Watch }) screen
        |> local

    _ ->
      local screen


updateEditor : (Editor -> Editor) -> Screen -> Screen
updateEditor update screen =
  let
    newEditor = Maybe.map update screen.editor
  in
    { screen | editor <- newEditor }


loadTrack : String -> Task Never ()
loadTrack slug =
  ServerApi.getTrack slug `andThen`
    \result ->
      case result of
        Ok track ->
          Signal.send actions.address (SetTrack track)
        Err _ ->
          Task.succeed ()


updateDims : (Int, Int) -> Screen -> Screen
updateDims (w, h) screen =
  let
    dims = (w - sidebarWidth, h)
    newEditor = Maybe.map (\e -> { e | dims <- dims } ) screen.editor
  in
    { screen | editor <- newEditor, dims <- dims }

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
    coordsMaybe = getMouseEventTile editor event
    newGrid = Maybe.map (\c -> deleteTile c editor.grid) coordsMaybe
      |> Maybe.withDefault editor.grid
  in
    { editor | grid <- newGrid }

updateTileAction : TileKind -> MouseEvent -> Editor -> Editor
updateTileAction kind event editor =
  let
    coordsMaybe = getMouseEventTile editor event
    newGrid = Maybe.map (\c -> createTile kind c editor.grid) coordsMaybe
      |> Maybe.withDefault editor.grid
  in
    { editor | grid <- newGrid }

getMouseEventTile : Editor -> MouseEvent -> Maybe Coords
getMouseEventTile editor event =
  let
    pointMaybe =
      case event of
        StartAt p -> Just p
        MoveFromTo p _ -> Just p
        EndAt _ -> Nothing
  in
    Maybe.map ((clickPoint editor) >> pointToHexCoords) pointMaybe

clickPoint : Editor -> (Int, Int) -> Point
clickPoint {dims, center} (x, y) =
  let
    (w, h) = dims
    (cx, cy) = center
    x' = toFloat (x - sidebarWidth) - cx - toFloat w / 2
    y' = toFloat y - cy - toFloat h / 2
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
          (xb - xa, yb - ya)
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


