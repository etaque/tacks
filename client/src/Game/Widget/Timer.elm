module Game.Widget.Timer exposing (..)

import Maybe.Extra as Maybe
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Game.Shared exposing (GameState, Timers, isStarted, raceTime)
import Game.Msg exposing (..)
import View.Utils as Utils


view : GameState -> Html GameMsg
view ({ timers, playerState } as gameState) =
    case timers.startTime of
        Just startTime ->
            let
                timer =
                    playerState.nextGate
                        |> Maybe.map (\_ -> startTime - timers.serverTime)
                        |> Maybe.withDefault (List.head playerState.crossedGates |> Maybe.withDefault 0)

                hasFinished =
                    Maybe.isNothing playerState.nextGate
            in
                div
                    [ classList
                        [ ( "timer", True )
                        , ( "is-started", isStarted gameState )
                        ]
                    ]
                    [ span
                        [ style [ ( "opacity", toString (timerOpacity gameState) ) ]
                        ]
                        [ text (Utils.formatTimer hasFinished timer) ]
                    , if List.isEmpty playerState.crossedGates then
                        text ""
                      else
                        a
                            [ onClick ExitRace
                            , class "exit-race"
                            , title "Exit race"
                            ]
                            [ Utils.mIcon "cancel" []
                            ]
                    ]

        Nothing ->
            a
                [ onClick StartRace
                , class "btn-floating btn-warn start-race"
                , title "Start race"
                ]
                [ Utils.mIcon "play_arrow" []
                ]


timerOpacity : GameState -> Float
timerOpacity gameState =
    if isStarted gameState then
        0.6
    else
        let
            ms =
                floor (raceTime gameState) % 1000
        in
            if ms < 500 then
                1
            else
                (1000 - toFloat ms) / 500
