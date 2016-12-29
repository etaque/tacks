module Page.PlayLive.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Page.PlayLive.Model exposing (..)
import Game.Msg exposing (GameMsg(ChatMsg))
import View.Layout as Layout exposing (Layout)
import Game.Render.All exposing (render)
import Game.Widget.Timer as Timer
import Game.Widget.Help as Help
import Game.Widget.Rankings as Rankings
import Game.Widget.LivePlayers as LivePlayers
import Game.Widget.Chat as Chat
import Game.Widget.Controls as Controls
import Constants
import Game.Shared exposing (GameState)
import View.Utils as Utils
import Route
import Dialog


pageTitle : LiveStatus -> Model -> String
pageTitle liveStatus model =
    let
        playersCount =
            List.length model.freePlayers + (List.concatMap .players model.races |> List.length)

        trackName =
            model.liveTrack
                |> dataMaybe
                |> Maybe.map (.track >> .name)
                |> Maybe.withDefault ""
    in
        "(" ++ toString playersCount ++ ") " ++ trackName


view : Context -> Model -> Layout Msg
view { device } model =
    case ( model.liveTrack, model.gameState ) of
        ( DataOk liveTrack, Just gameState ) ->
            { id = "play-track"
            , appbar = appbar model liveTrack gameState
            , maybeNav = Nothing
            , content =
                (baseLayers device model liveTrack gameState)
                    ++ (chatLayers device model)
                    ++ (controlLayers device)
            , dialog =
                Maybe.map
                    (dialogContent model liveTrack >> Dialog.view DialogMsg model.dialog)
                    model.dialogKind
            }

        _ ->
            Layout.empty "play-track loading"


baseLayers : Device -> Model -> LiveTrack -> GameState -> List (Html Msg)
baseLayers device model liveTrack gameState =
    [ render
        ( device.size.width
        , device.size.height - Constants.appbarHeight
        )
        gameState
    , toolbar liveTrack model gameState
    , contextAside model liveTrack gameState
    ]


chatLayers : Device -> Model -> List (Html Msg)
chatLayers device { chat } =
    if device.control /= TouchControl then
        [ Chat.messages chat
        , Html.map (GameMsg << ChatMsg) (Chat.inputField chat)
        ]
    else
        []


controlLayers : Device -> List (Html Msg)
controlLayers device =
    if device.control == TouchControl then
        [ Html.map GameMsg Controls.view ]
    else
        []


appbar : Model -> LiveTrack -> GameState -> List (Html Msg)
appbar model { track } gameState =
    [ div
        [ class "appbar-left" ]
        [ if track.status == Draft then
            Utils.linkTo
                (Route.EditTrack track.id)
                [ class "exit"
                , title "Back to editor"
                ]
                [ Utils.mIcon "edit" [] ]
          else
            Utils.linkTo
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
    , div
        [ class "appbar-right" ]
        []
    ]


toolbar : LiveTrack -> Model -> GameState -> Html Msg
toolbar liveTrack model gameState =
    if liveTrack.track.status == Draft then
        text ""
    else
        div
            [ class "toolbar" ]
            [ contextBadge model gameState
            , div
                [ class "toolbar-group" ]
                [ div
                    [ class "toolbar-item"
                    , onClick (ShowDialog RankingsDialog)
                    ]
                    [ Utils.mIcon "timeline" [] ]
                ]
            ]


contextBadge : Model -> GameState -> Html Msg
contextBadge model gameState =
    let
        playersCount =
            List.length (List.concatMap .players model.races)
                + List.length model.freePlayers
    in
        div
            [ class "toolbar-group"
            , onClick (ShowContext (not model.showContext))
            ]
            [ div
                [ classList
                    [ ( "toolbar-item mini-context", True )
                    , ( "active", model.showContext )
                    ]
                ]
                [ span
                    [ class "players-count" ]
                    [ text (toString playersCount) ]
                , Utils.mIcon "people" []
                , span [ class "separator" ] []
                , span
                    [ class "gates" ]
                    [ if Game.Shared.isStarted gameState then
                        text <|
                            toString (List.length gameState.playerState.crossedGates)
                                ++ "/"
                                ++ toString (List.length gameState.course.gates + 1)
                      else
                        text "-/-"
                    ]
                ]
            ]


contextAside : Model -> LiveTrack -> GameState -> Html Msg
contextAside model liveTrack gameState =
    aside
        [ classList
            [ ( "context", True )
            , ( "visible", model.showContext )
            ]
        ]
        [ LivePlayers.view model.races model.freePlayers
        ]


dialogContent : Model -> LiveTrack -> DialogKind -> Dialog.Layout Msg
dialogContent model liveTrack kind =
    case kind of
        ChooseControl ->
            Dialog.emptyLayout

        RankingsDialog ->
            { header = [ Dialog.title "Rankings" ]
            , body =
                [ Html.map GameMsg
                    (Rankings.view model.ghostRuns liveTrack.meta)
                ]
            , footer = []
            }

        NewBestTime ->
            Dialog.emptyLayout
