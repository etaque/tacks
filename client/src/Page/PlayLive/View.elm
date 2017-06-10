module Page.PlayLive.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Page.PlayLive.Model exposing (..)
import Game.Msg exposing (GameMsg(ChatMsg))
import View.Layout as Layout exposing (Layout)
import Game.Render
import Game.Widget.Timer as Timer
import Game.Widget.Rankings as Rankings
import Game.Widget.LivePlayers as LivePlayers
import Game.Widget.Chat as Chat
import Game.Widget.Controls as Controls
import Constants
import Game.Shared exposing (GameState)
import View.Utils as Utils
import View.DeviceControl
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
                    (dialogContent device model liveTrack >> Dialog.view DialogMsg model.dialog)
                    model.dialogKind
            }

        _ ->
            Layout.empty "play-track loading"


baseLayers : Device -> Model -> LiveTrack -> GameState -> List (Html Msg)
baseLayers device model liveTrack gameState =
    let
        viewDims =
            ( device.size.width
            , device.size.height - Constants.appbarHeight
            )
    in
        Game.Render.layers viewDims gameState
            ++ [ toolbar device liveTrack model gameState
               , contextAside model liveTrack gameState
               ]


chatLayers : Device -> Model -> List (Html Msg)
chatLayers device { chat } =
    [ Html.map (GameMsg << ChatMsg) (Chat.view chat) ]


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


toolbar : Device -> LiveTrack -> Model -> GameState -> Html Msg
toolbar device liveTrack model gameState =
    if liveTrack.track.status == Draft then
        text ""
    else
        div
            [ class "toolbar" ]
            [ contextBadge model gameState
            , div
                [ class "toolbar-group" ]
                [ button
                    [ class "toolbar-item"
                    , onClick (ShowDialog RankingsDialog)
                    , title "Rankings"
                    ]
                    [ Utils.mIcon "timeline" [] ]
                , button
                    [ class "toolbar-item"
                    , onClick (ShowDialog ChooseControl)
                    , title "Control mode"
                    ]
                    [ Utils.mIcon (View.DeviceControl.icon device.control) [] ]
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
            [ classList
                [ ( "toggle-context", True )
                , ( "active", model.showContext )
                ]
            , onClick (ShowContext (not model.showContext))
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
            , span [ class "separator" ] []
            , Utils.mIcon "arrow_drop_down" [ "indicator" ]
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


dialogContent : Device -> Model -> LiveTrack -> DialogKind -> Dialog.Layout Msg
dialogContent device model liveTrack kind =
    case kind of
        ChooseControl ->
            { header = [ Dialog.title "Choose control mode" ]
            , body = [ Html.map GameMsg (View.DeviceControl.view device.control) ]
            , footer = []
            }

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
