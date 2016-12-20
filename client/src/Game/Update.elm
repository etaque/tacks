module Game.Update exposing (..)

import Game.Msg exposing (..)
import Game.Shared exposing (..)
import Game.Output as Output
import Game.Input as Input
import Ports
import Response exposing (..)
import Model.Shared exposing (..)
import Dict exposing (Dict)
import Window
import AnimationFrame
import Keyboard.Extra as Keyboard
import Game.Touch as Touch
import Game.Steps as Steps
import Keyboard
import Task


subscriptions : WithGame a -> Sub GameMsg
subscriptions model =
    Sub.batch
        [ AnimationFrame.times Frame
        , Sub.map KeyboardMsg Keyboard.subscriptions
        , Window.resizes WindowSize
        , Sub.map ChatMsg (Keyboard.downs (keyCodeToMsg model.chat))
        , Ports.deviceOrientation (TouchMsg << Touch.Orientation)
        ]


mount : Cmd GameMsg
mount =
    Task.perform WindowSize Window.size


update : Player -> (Output.ServerMsg -> Cmd GameMsg) -> GameMsg -> WithGame a -> Response (WithGame a) GameMsg
update player toServerCmd msg model =
    case msg of
        KeyboardMsg keyboardMsg ->
            if model.chat.focus then
                res model Cmd.none
            else
                let
                    ( newKeyboard, keyboardCmd ) =
                        Keyboard.update keyboardMsg model.keyboard
                in
                    res { model | keyboard = newKeyboard } (Cmd.map KeyboardMsg keyboardCmd)

        TouchMsg touchMsg ->
            res { model | touch = Touch.update touchMsg model.touch } Cmd.none

        WindowSize size ->
            res { model | dims = ( size.width, size.height ) } Cmd.none

        RaceUpdate raceInput ->
            res
                { model | gameState = Maybe.map (updateRaceInput raceInput) model.gameState }
                Cmd.none

        Frame time ->
            model.gameState
                |> Maybe.map (updateFrame time toServerCmd model)
                |> Maybe.withDefault (res model Cmd.none)

        StartRace ->
            res model (toServerCmd Output.StartRace)

        ExitRace ->
            res
                { model | gameState = Maybe.map clearCrossedGates model.gameState }
                (toServerCmd Output.EscapeRace)

        AddGhost runId player ->
            let
                newGhostRuns =
                    Dict.insert runId player model.ghostRuns
            in
                res { model | ghostRuns = newGhostRuns } (toServerCmd (Output.AddGhost runId player))

        RemoveGhost runId ->
            let
                newGhostRuns =
                    Dict.remove runId model.ghostRuns
            in
                res { model | ghostRuns = newGhostRuns } (toServerCmd (Output.RemoveGhost runId))

        ChatMsg chatMsg ->
            updateChat toServerCmd chatMsg model.chat
                |> mapModel (\newChat -> { model | chat = newChat })


updateFrame : Float -> (Output.ServerMsg -> Cmd GameMsg) -> WithGame a -> GameState -> Response (WithGame a) GameMsg
updateFrame time toServerCmd model gameState =
    let
        keyboardInput =
            Input.merge (Input.keyboardInput model.keyboard) (Input.touchInput model.touch)

        gameInput =
            Input.GameInput
                keyboardInput
                model.dims

        newGameState =
            Steps.run gameInput time gameState

        serverCmd =
            toServerCmd (Output.UpdatePlayer (Output.playerOutput gameState))
    in
        if time - model.lastPush > 33 then
            res { model | gameState = Just newGameState, lastPush = time } serverCmd
        else
            res { model | gameState = Just newGameState } Cmd.none


updateRaceInput : Input.RaceInput -> GameState -> GameState
updateRaceInput input ({ playerState, timers } as gameState) =
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


updateChat : (Output.ServerMsg -> Cmd GameMsg) -> ChatMsg -> Chat -> Response Chat GameMsg
updateChat serverSocket msg model =
    case msg of
        EnterChat withFocus ->
            res { model | focus = True } (Ports.setFocus chatFieldId)

        ExitChat withBlur ->
            let
                cmd =
                    if withBlur then
                        Ports.setBlur chatFieldId
                    else
                        Cmd.none
            in
                res { model | focus = False } cmd

        UpdateField s ->
            res { model | field = s } Cmd.none

        SubmitMessage ->
            if not (String.isEmpty model.field) then
                res
                    { model | field = "" }
                    (Cmd.batch [ serverSocket (Output.SendMessage model.field), Ports.setBlur chatFieldId ])
            else
                res model (Ports.setBlur chatFieldId)

        AddMessage msg ->
            res
                { model | messages = List.take 30 (msg :: model.messages) }
                (Ports.scrollToBottom chatMessagesId)

        NoOp ->
            res model Cmd.none


keyCodeToMsg : Chat -> Int -> ChatMsg
keyCodeToMsg model code =
    if model.focus then
        if code == enter then
            SubmitMessage
        else if code == esc then
            ExitChat True
        else
            NoOp
    else if code == enter then
        EnterChat True
    else
        NoOp


esc : Int
esc =
    27


enter : Int
enter =
    13


clearCrossedGates : GameState -> GameState
clearCrossedGates ({ playerState } as gameState) =
    { gameState | playerState = { playerState | crossedGates = [] } }
