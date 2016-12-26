module Game.Update exposing (..)

import Game.Msg exposing (..)
import Game.Shared exposing (..)
import Game.Output as Output
import Ports
import Response exposing (..)
import Model.Shared exposing (..)
import Dict exposing (Dict)
import Window
import AnimationFrame
import Keyboard.Extra as Keyboard
import Game.Steps as Steps
import Keyboard
import Task


subscriptions : WithGame a -> Sub GameMsg
subscriptions model =
    Sub.batch
        [ AnimationFrame.times Frame
        , Window.resizes WindowSize
        , Keyboard.downs (downKeyToMsg model)
        , Keyboard.ups (upKeyToMsg model)
        ]


mount : Cmd GameMsg
mount =
    Task.perform WindowSize Window.size


update : Player -> (Output.ServerMsg -> Cmd GameMsg) -> GameMsg -> WithGame a -> Response (WithGame a) GameMsg
update player toServerCmd msg model =
    case msg of
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

        Left b ->
            res { model | direction = ( b, Tuple.second model.direction ) } Cmd.none

        Right b ->
            res { model | direction = ( Tuple.first model.direction, b ) } Cmd.none

        Tack ->
            res
                { model | gameState = Maybe.map Steps.setTack model.gameState }
                Cmd.none

        AutoVmg ->
            res
                { model | gameState = Maybe.map Steps.setAutoVmg model.gameState }
                Cmd.none

        LockWindAngle ->
            res
                { model | gameState = Maybe.map Steps.lockWindAngle model.gameState }
                Cmd.none

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

        GameNoOp ->
            res model Cmd.none


updateFrame : Float -> (Output.ServerMsg -> Cmd GameMsg) -> WithGame a -> GameState -> Response (WithGame a) GameMsg
updateFrame time toServerCmd model gameState =
    let
        asArrow =
            case model.direction of
                ( True, True ) ->
                    0

                ( True, False ) ->
                    -1

                ( False, True ) ->
                    1

                ( False, False ) ->
                    0

        newGameState =
            Steps.run model.dims asArrow time gameState

        serverCmd =
            toServerCmd (Output.UpdatePlayer (Output.playerOutput gameState))
    in
        if time - model.lastPush > 33 then
            res { model | gameState = Just newGameState, lastPush = time } serverCmd
        else
            res { model | gameState = Just newGameState } Cmd.none


updateRaceInput : RaceInput -> GameState -> GameState
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
            if String.isEmpty model.field then
                res model (Ports.setBlur chatFieldId)
            else
                res { model | field = "" } (serverSocket (Output.SendMessage model.field))

        AddMessage msg ->
            res
                { model | messages = List.take 30 (msg :: model.messages) }
                (Ports.scrollToBottom chatMessagesId)


downKeyToMsg : WithGame a -> Int -> GameMsg
downKeyToMsg model code =
    if model.chat.focus then
        case Keyboard.fromCode code of
            Keyboard.Enter ->
                ChatMsg (SubmitMessage)

            Keyboard.Escape ->
                ChatMsg (ExitChat True)

            _ ->
                GameNoOp
    else
        case Keyboard.fromCode code of
            Keyboard.Enter ->
                ChatMsg (EnterChat True)

            Keyboard.ArrowUp ->
                AutoVmg

            Keyboard.ArrowDown ->
                LockWindAngle

            Keyboard.Space ->
                Tack

            Keyboard.ArrowLeft ->
                Left True

            Keyboard.ArrowRight ->
                Right True

            _ ->
                GameNoOp


upKeyToMsg : WithGame a -> Int -> GameMsg
upKeyToMsg model code =
    case Keyboard.fromCode code of
        Keyboard.ArrowLeft ->
            Left False

        Keyboard.ArrowRight ->
            Right False

        _ ->
            GameNoOp


clearCrossedGates : GameState -> GameState
clearCrossedGates ({ playerState } as gameState) =
    { gameState | playerState = { playerState | crossedGates = [] } }
