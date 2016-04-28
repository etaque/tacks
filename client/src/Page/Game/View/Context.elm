module Page.Game.View.Context (..) where

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Game.Models exposing (GameState, Timers)
import Page.Game.Model exposing (..)
import Page.Game.Update exposing (addr)
import Page.Game.View.Players as PlayersView
import View.Utils as Utils
import Route exposing (..)


nav : Model -> LiveTrack -> GameState -> List Html
nav model liveTrack gameState =
  [ h2
      []
      [ Utils.linkTo
          (ShowTrack liveTrack.track.id)
          []
          [ text liveTrack.track.name ]
      ]
  ]


raceAction : GameState -> Html
raceAction { timers, playerState } =
  case timers.startTime of
    Just startTime ->
      if List.isEmpty playerState.crossedGates then
        text ""
      else
        a
          [ onClick addr ExitRace
          , class "btn-floating btn-warn btn-black exit-race"
          , title "Exit race"
          ]
          [ Utils.mIcon "cancel" []
          ]

    Nothing ->
      a
        [ onClick addr StartRace
        , class "btn-floating btn-warn start-race"
        , title "Start race"
        ]
        [ Utils.mIcon "play_arrow" []
        ]


sidebar : Model -> LiveTrack -> GameState -> List Html
sidebar model liveTrack gameState =
  let
    blocks =
      if liveTrack.track.status == Draft then
        draftBlocks liveTrack
      else
        liveBlocks gameState model liveTrack
  in
    blocks


trackNav : LiveTrack -> Html
trackNav liveTrack =
  div
    [ class "track-menu" ]
    [ h2 [] [ text liveTrack.track.name ] ]


draftBlocks : LiveTrack -> List Html
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
          [ ]
          [ text "This is a draft, you're the only one seeing this race track." ]
      ]
  ]


liveBlocks : GameState -> Model -> LiveTrack -> List Html
liveBlocks gameState model liveTrack =
  (tabs model)
    :: case model.tab of
        LiveTab ->
          [ PlayersView.block model ]

        RankingsTab ->
          [ rankingsBlock model.ghostRuns liveTrack ]

        HelpTab ->
          [ helpBlock ]


tabs : Model -> Html
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
      (\t -> onClick addr (SetTab t))
      ((==) tab)


rankingsBlock : Dict String Player -> LiveTrack -> Html
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


rankingItem : (String -> Bool) -> Ranking -> Html
rankingItem isGhost ranking =
  let
    attrs =
      if isGhost ranking.runId then
        [ class "ranking remove-ghost"
        , onClick addr (RemoveGhost ranking.runId)
        , title "Remove from ghosts"
        ]
      else
        [ class "ranking add-ghost"
        , onClick addr (AddGhost ranking.runId ranking.player)
        , title "Add to ghosts"
        ]
  in
    li
      attrs
      [ span [ class "rank" ] [ text (toString ranking.rank) ]
      , span [ class "time" ] [ text (Utils.formatTimer True ranking.finishTime) ]
      , Utils.playerWithAvatar ranking.player
      ]


helpBlock : Html
helpBlock =
  div
    [ class "aside-module module-help" ]
    [ dl [] helpItems ]


helpItems : List Html
helpItems =
  let
    items =
      [ ( "left/right", "turn" )
      , ( "left/right + shift", "adjust" )
      , ( "enter", "lock angle to wind" )
      , ( "space", "tack or jibe" )
      ]
  in
    List.concatMap helpItem items


helpItem : ( String, String ) -> List Html
helpItem ( keys, role ) =
  [ dt [] [ text role ], dd [] [ text keys ] ]
