module Page.PlayTimeTrial.View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Model.Shared exposing (..)
import Page.PlayTimeTrial.Model exposing (..)
import Page.PlayTimeTrial.ContextView as ContextView
import Game.Shared exposing (GameState, Timers, isStarted, raceTime)
import Game.Widget.Timer as Timer
import Game.Widget.Help as Help
import Game.Widget.Rankings as Rankings
import Game.Widget.Controls as Controls
import View.Layout as Layout exposing (Layout)
import View.Utils as Utils
import Game.Render.All exposing (render)
import Route exposing (..)
import Constants
import Dialog


pageTitle : Context -> String
pageTitle ctx =
    case ctx.liveStatus.liveTimeTrial of
        Just { track } ->
            "Time trial - " ++ track.name

        _ ->
            ""


view : Context -> Model -> Layout Msg
view { device, liveStatus } model =
    case ( liveStatus.liveTimeTrial, model.gameState ) of
        ( Just liveTimeTrial, Just gameState ) ->
            { id = "play-time-trial"
            , appbar = appbar model liveTimeTrial gameState
            , maybeNav = Nothing
            , content =
                (baseLayers device model liveTimeTrial gameState)
                    ++ (controlLayers device)
            , dialog =
                Maybe.map
                    (dialogContent model liveTimeTrial >> Dialog.view DialogMsg model.dialog)
                    model.dialogKind
            }

        _ ->
            Layout.empty
                "play-time-trial loading"


baseLayers : Device -> Model -> LiveTimeTrial -> GameState -> List (Html Msg)
baseLayers device model liveTimeTrial gameState =
    [ render
        ( device.size.width
        , device.size.height - Constants.appbarHeight
        )
        gameState
    , toolbar model liveTimeTrial gameState
    , contextAside model liveTimeTrial gameState
    ]


controlLayers : Device -> List (Html Msg)
controlLayers device =
    if device.control == TouchControl then
        [ Html.map GameMsg Controls.view ]
    else
        []


appbar : Model -> LiveTimeTrial -> GameState -> List (Html Msg)
appbar model { track } gameState =
    [ div
        [ class "appbar-left" ]
        [ Utils.linkTo
            Route.Home
            [ class "exit"
            , title "Back to home"
            ]
            [ Utils.mIcon "arrow_back" [] ]
        , h2 [] [ text track.name ]
        ]
    , div
        [ class "appbar-center" ]
        [ Html.map GameMsg (Timer.view gameState) ]
    , div [ class "appbar-right" ] []
    ]


toolbar : Model -> LiveTimeTrial -> GameState -> Html Msg
toolbar model liveTimeTrial gameState =
    div
        [ class "toolbar" ]
        [ contextBadge model gameState
        , div
            [ class "toolbar-group"
            ]
            [ button
                [ class "toolbar-item"
                , onClick (ShowDialog RankingsDialog)
                ]
                [ Utils.mIcon "timeline" [] ]
            ]
        ]


contextBadge : Model -> GameState -> Html Msg
contextBadge model gameState =
    div
        [ classList
            [ ( "toggle-context", True )
            , ( "active", model.showContext )
            ]
        , onClick (ShowContext (not model.showContext))
        ]
        [ span
            [ class "gates" ]
            [ if Game.Shared.isStarted gameState then
                text <|
                    toString (List.length gameState.playerState.crossedGates)
                        ++ "/"
                        ++ toString (List.length gameState.course.gates + 1)
              else
                text "-/-"
            ]
        , span [ class "separator" ] []
        , Utils.mIcon "arrow_drop_down" [ "indicator" ]
        ]


contextAside : Model -> LiveTimeTrial -> GameState -> Html Msg
contextAside model liveTimeTrial gameState =
    aside
        [ classList
            [ ( "context", True )
            , ( "visible", model.showContext )
            ]
        ]
        [ ContextView.view model liveTimeTrial gameState ]


dialogContent : Model -> LiveTimeTrial -> DialogKind -> Dialog.Layout Msg
dialogContent model liveTimeTrial kind =
    case kind of
        ChooseControl ->
            Dialog.emptyLayout

        RankingsDialog ->
            { header = [ Dialog.title "Rankings" ]
            , body =
                [ Html.map GameMsg
                    (Rankings.view model.ghostRuns liveTimeTrial.meta)
                ]
            , footer = []
            }

        NewBestTime ->
            Dialog.emptyLayout
