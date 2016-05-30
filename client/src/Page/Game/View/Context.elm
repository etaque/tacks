module Page.Game.View.Context exposing (..)

import Dict exposing (Dict)
import Html.App as Html
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Game.Models exposing (GameState, Timers, isStarted, raceTime)
import CoreExtra
import Page.Game.Model exposing (..)
import Page.Game.View.Players as PlayersView
import Page.Game.Chat.View as Chat
import View.Utils as Utils
import Route exposing (..)


toolbar : Model -> LiveTrack -> GameState -> List (Html Msg)
toolbar model { track } gameState =
  [ div
      [ class "toolbar-left" ]
      [ if track.status == Draft then
          Utils.linkTo
            (Route.EditTrack track.id)
            [ class "exit"
            , title "Back to editor"
            ]
            [ Utils.mIcon "close" [] ]
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
      [ class "toolbar-center" ]
      (raceStatus gameState)
  , div [ class "toolbar-right" ] []
  ]


raceStatus : GameState -> List (Html Msg)
raceStatus ({ timers, playerState } as gameState) =
  case timers.startTime of
    Just startTime ->
      let
        timer =
          playerState.nextGate
            |> Maybe.map (\_ -> startTime - timers.now)
            |> Maybe.withDefault (List.head playerState.crossedGates |> Maybe.withDefault 0)

        hasFinished =
          CoreExtra.isNothing playerState.nextGate
      in
        [ div
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
        ]

    Nothing ->
      [ a
          [ onClick StartRace
          , class "btn-floating btn-warn start-race"
          , title "Start race"
          ]
          [ Utils.mIcon "play_arrow" []
          ]
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


sidebar : Model -> LiveTrack -> GameState -> List (Html Msg)
sidebar model liveTrack gameState =
  let
    blocks =
      if liveTrack.track.status == Draft then
        draftBlocks liveTrack
      else
        liveBlocks gameState model liveTrack
  in
    blocks


trackNav : LiveTrack -> Html Msg
trackNav liveTrack =
  div
    [ class "track-menu" ]
    [ h2 [] [ text liveTrack.track.name ] ]


draftBlocks : LiveTrack -> List (Html Msg)
draftBlocks { track } =
  [ div
      [ class "draft" ]
      [ div
          [ class "actions" ]
          [ Utils.linkTo
              (EditTrack track.id)
              [ class "btn-raised btn-primary" ]
              [ Utils.mIcon "edit" [], text "Edit draft" ]
          ]
      , p
          []
          [ text "This is a draft, you're the only one seeing this race track." ]
      ]
  ]


liveBlocks : GameState -> Model -> LiveTrack -> List (Html Msg)
liveBlocks gameState model liveTrack =
  (tabs model)
    :: case model.tab of
        LiveTab ->
          [ PlayersView.block model
          , Html.map ChatMsg (Chat.messages model.chat)
          ]

        RankingsTab ->
          [ rankingsBlock model.ghostRuns liveTrack ]

        HelpTab ->
          [ helpBlock ]


tabs : Model -> Html Msg
tabs { tab } =
  let
    items =
      [ ( "Live", LiveTab )
      , ( "Runs", RankingsTab )
      , ( "Help", HelpTab )
      ]
  in
    Utils.tabsRow
      items
      (\t -> onClick (SetTab t))
      ((==) tab)


rankingsBlock : Dict String Player -> LiveTrack -> Html Msg
rankingsBlock ghostRuns { meta } =
  div
    [ class "aside-module module-rankings" ]
    [ ul
        [ class "list-unstyled list-rankings" ]
        (List.map (rankingItem (\runId -> Dict.member runId ghostRuns)) meta.rankings)
    , if Dict.isEmpty ghostRuns then
        div
          [ class "empty" ]
          [ text "Click on a player to add its ghost run." ]
      else
        text ""
    ]


rankingItem : (String -> Bool) -> Ranking -> Html Msg
rankingItem isGhost ranking =
  let
    attrs =
      if isGhost ranking.runId then
        [ class "ranking remove-ghost"
        , onClick (RemoveGhost ranking.runId)
        , title "Remove from ghosts"
        ]
      else
        [ class "ranking add-ghost"
        , onClick (AddGhost ranking.runId ranking.player)
        , title "Add to ghosts"
        ]
  in
    li
      attrs
      [ span [ class "rank" ] [ text (toString ranking.rank) ]
      , span [ class "time" ] [ text (Utils.formatTimer True ranking.finishTime) ]
      , Utils.playerWithAvatar ranking.player
      ]


helpBlock : Html Msg
helpBlock =
  div
    [ class "aside-module module-help" ]
    [ dl [] helpItems ]


helpItems : List (Html Msg)
helpItems =
  let
    items =
      [ ( "left/right", "turn" )
      , ( "left/right + shift", "adjust" )
      , ( "up", "lock angle to wind" )
      , ( "space", "tack or jibe" )
      ]
  in
    List.concatMap helpItem items


helpItem : ( String, String ) -> List (Html Msg)
helpItem ( keys, role ) =
  [ dt [] [ text role ], dd [] [ text keys ] ]
