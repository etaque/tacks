module Game.Steps exposing (..)

import Time exposing (Time)
import Model.Shared exposing (..)
import Game.Shared exposing (..)
import Game.Steps.GateCrossing exposing (gateCrossingStep)
import Game.Steps.Moving as Moving
import Game.Steps.Turning exposing (turningStep)
import Game.Steps.Vmg exposing (vmgStep)
import Game.Steps.PlayerWind exposing (playerWindStep)
import Game.Steps.WindHistory exposing (windHistoryStep)
import Game.Steps.Gusts exposing (gustsStep)
import Game.Steps.Viewport exposing (viewportStep)


setTack : GameState -> GameState
setTack ({ playerState } as gameState) =
    let
        newPlayerState =
            { playerState | tackTarget = Just -playerState.windAngle }
    in
        { gameState | playerState = newPlayerState }


setAutoVmg : GameState -> GameState
setAutoVmg ({ playerState } as gameState) =
    let
        newPlayerState =
            { playerState | tackTarget = Just (windAngleOnVmg playerState) }
    in
        { gameState | playerState = newPlayerState }


lockWindAngle : GameState -> GameState
lockWindAngle ({ playerState } as gameState) =
    let
        newPlayerState =
            { playerState | controlMode = FixedAngle }
    in
        { gameState | playerState = newPlayerState }


run : Dims -> Int -> Time -> GameState -> GameState
run dims direction time ({ timers } as gameState) =
    let
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
            |> playerStep direction clientDelta
            |> opponentsStep serverDelta
            |> windHistoryStep
            |> viewportStep gameState.playerState.position dims


opponentsStep : Time -> GameState -> GameState
opponentsStep elapsed gameState =
    let
        newOpponents =
            moveOpponents elapsed (isStarted gameState) gameState.course gameState.opponents
    in
        { gameState | opponents = newOpponents }


playerStep : Int -> Float -> GameState -> GameState
playerStep direction elapsed gameState =
    let
        playerState =
            turningStep elapsed direction gameState.playerState
                |> playerWindStep gameState
                |> vmgStep
                |> Moving.playerStep elapsed (isStarted gameState) gameState.course
                |> gateCrossingStep gameState.playerState gameState
                |> playerTimeStep elapsed
    in
        { gameState | playerState = playerState }


moveOpponents : Time -> Bool -> Course -> List Opponent -> List Opponent
moveOpponents delta started course opponents =
    List.map
        (\o -> { o | state = Moving.opponentStep delta started course o.state })
        opponents


playerTimeStep : Float -> PlayerState -> PlayerState
playerTimeStep elapsed state =
    { state | time = state.time + elapsed }
