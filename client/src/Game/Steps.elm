module Game.Steps exposing (..)

import Time exposing (Time)
import Model.Shared exposing (..)
import Game.Input as Input
import Game.Shared exposing (..)
import Constants
import Game.Steps.GateCrossing exposing (gateCrossingStep)
import Game.Steps.Moving as Moving
import Game.Steps.Turning exposing (turningStep)
import Game.Steps.Vmg exposing (vmgStep)
import Game.Steps.PlayerWind exposing (playerWindStep)
import Game.Steps.WindHistory exposing (windHistoryStep)
import Game.Steps.Gusts exposing (gustsStep)
import Game.Steps.Viewport exposing (viewportStep)


run : Input.GameInput -> Time -> GameState -> GameState
run { keyboard, dims } time ({ timers } as gameState) =
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
            |> viewportStep gameState.playerState.position gameDims


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


moveOpponents : Time -> Bool -> Course -> List Opponent -> List Opponent
moveOpponents delta started course opponents =
    List.map
        (\o -> { o | state = Moving.opponentStep delta started course o.state })
        opponents


playerTimeStep : Float -> PlayerState -> PlayerState
playerTimeStep elapsed state =
    { state | time = state.time + elapsed }
