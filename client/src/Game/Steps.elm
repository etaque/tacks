module Game.Steps exposing (..)

import Time exposing (Time)
import Model.Shared exposing (..)
import Game.Inputs as Input
import Game.Shared exposing (..)
import Game.Utils as Utils
import Constants
import Game.Steps.GateCrossing exposing (gateCrossingStep)
import Game.Steps.Moving as Moving
import Game.Steps.Turning exposing (turningStep)
import Game.Steps.Vmg exposing (vmgStep)
import Game.Steps.PlayerWind exposing (playerWindStep)
import Game.Steps.WindHistory exposing (windHistoryStep)
import Game.Steps.Gusts exposing (gustsStep)


frameStep : Input.GameInput -> Time -> GameState -> GameState
frameStep { keyboard, dims } time ({ timers } as gameState) =
    let
        keyboardInputWithFocus =
            if gameState.chatting then
                Input.initialKeyboard
            else
                keyboard

        gameDims =
            ( Tuple.first dims - Constants.sidebarWidth
            , Tuple.second dims
            )

        clientDelta =
            time - gameState.timers.localTime

        serverDelta =
            time - (max gameState.timers.lastServerUpdate gameState.timers.localTime)

        newTimers =
            { timers
                | localTime = time
                , serverTime = timers.serverTime + serverDelta
            }
    in
        { gameState | timers = newTimers }
            |> gustsStep
            |> playerStep keyboardInputWithFocus clientDelta
            |> opponentsStep serverDelta
            |> windHistoryStep
            |> centerStep gameState.playerState.position gameDims


raceInputStep : Input.RaceInput -> GameState -> GameState
raceInputStep input ({ playerState, timers } as gameState) =
    let
        newTimers =
            { timers
                | serverTime = input.serverTime
                , startTime = input.startTime
                , lastServerUpdate = timers.localTime
            }
    in
        { gameState
            | opponents = input.opponents
            , ghosts = input.ghosts
            , wind = input.wind
            , tallies = input.tallies
            , timers = newTimers
        }


opponentsStep : Time -> GameState -> GameState
opponentsStep elapsed gameState =
    let
        newOpponents =
            moveOpponents elapsed (isStarted gameState) gameState.course gameState.opponents
    in
        { gameState | opponents = newOpponents }


playerStep : Input.KeyboardInput -> Float -> GameState -> GameState
playerStep keyboardInput elapsed gameState =
    let
        playerState =
            turningStep elapsed keyboardInput gameState.playerState
                |> playerWindStep gameState
                |> vmgStep
                |> Moving.playerStep elapsed (isStarted gameState) gameState.course
                |> gateCrossingStep gameState.playerState gameState
                |> playerTimeStep elapsed
    in
        { gameState | playerState = playerState }


centerStep : Point -> ( Int, Int ) -> GameState -> GameState
centerStep ( px, py ) dims ({ center, playerState, course } as gameState) =
    let
        ( cx, cy ) =
            center

        ( px_, py_ ) =
            playerState.position

        ( w, h ) =
            Utils.floatify dims

        ( ( xMax, yMax ), ( xMin, yMin ) ) =
            areaBox course.area

        newCenter =
            ( axisCenter px px_ cx w xMin xMax
            , axisCenter py py_ cy h yMin yMax
            )
    in
        { gameState | center = newCenter }


axisCenter : Float -> Float -> Float -> Float -> Float -> Float -> Float
axisCenter p p_ c window areaMin areaMax =
    let
        offset =
            (window / 2) - (window * 0.48)

        outOffset =
            (window / 2) - Constants.hexRadius

        delta =
            p_ - p

        minExit =
            delta < 0 && p_ < c - offset

        maxExit =
            delta > 0 && p_ > c + offset
    in
        if minExit then
            if areaMin > c - outOffset then
                c
            else
                c + delta
        else if maxExit then
            if areaMax < c + outOffset then
                c
            else
                c + delta
        else
            c


moveOpponents : Time -> Bool -> Course -> List Opponent -> List Opponent
moveOpponents delta started course opponents =
    List.map
        (\o -> { o | state = Moving.opponentStep delta started course o.state })
        opponents


playerTimeStep : Float -> PlayerState -> PlayerState
playerTimeStep elapsed state =
    { state | time = state.time + elapsed }
