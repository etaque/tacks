module Page.Game.SideView (..) where

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Game.Models exposing (GameState, Timers)
import Page.Game.Model exposing (..)
import Page.Game.Update exposing (addr)
import Page.Game.PlayersView as PlayersView
import View.Sidebar as Sidebar
import View.Utils as Utils
import Route exposing (..)


view : Model -> LiveTrack -> GameState -> List Html
view model liveTrack gameState =
  let
    blocks =
      if liveTrack.track.status == Draft then
        draftBlocks liveTrack
      else
        liveBlocks gameState model liveTrack
  in
    Sidebar.logo :: (trackNav liveTrack) :: blocks


trackNav : LiveTrack -> Html
trackNav liveTrack =
  div
    [ class "track-menu" ]
    [ h2 [] [ text liveTrack.track.name ] ]


draftBlocks : LiveTrack -> List Html
draftBlocks { track } =
  [ p
      [ class "draft-warning" ]
      [ text "This is a draft, you're the only one seeing this race track." ]
  , div
      [ class "form-actions" ]
      [ Utils.linkTo
          (EditTrack track.id)
          [ class "btn btn-block btn-primary" ]
          [ text "Edit draft" ]
      ]
  ]


liveBlocks : GameState -> Model -> LiveTrack -> List Html
liveBlocks gameState model liveTrack =
  [ raceActions gameState
  , PlayersView.block model
  , ghostsBlock model.ghostRuns
  , rankingsBlock (\runId -> Dict.member runId model.ghostRuns) liveTrack
  , helpBlock
  ]


raceActions : GameState -> Html
raceActions { timers, playerState } =
  div
    [ class "race-actions" ]
    [ case timers.startTime of
        Just startTime ->
          if List.isEmpty playerState.crossedGates then
            text ""
          else
            a
              [ onClick addr ExitRace
              , class "btn btn-danger btn-block"
              ]
              [ text "Exit race" ]

        Nothing ->
          a
            [ onClick addr StartRace
            , class "btn btn-default btn-block"
            ]
            [ text "Start race" ]
    ]


ghostsBlock : Dict String Player -> Html
ghostsBlock ghostRuns =
  div
    [ class "aside-module module-ghosts" ]
    [ Utils.moduleTitle "Ghosts"
    , if Dict.isEmpty ghostRuns then
        div
          [ class "empty" ]
          [ text "Click on some of the players below to add ghosts on the track" ]
      else
        ul
          [ class "list-unstyled list-ghosts" ]
          (List.map ghostItem (Dict.toList ghostRuns))
    ]


ghostItem : ( String, Player ) -> Html
ghostItem ( runId, player ) =
  li
    [ onClick addr (RemoveGhost runId)
    ]
    [ span
        [ class "handle"
        ]
        [ text (Utils.playerHandle player)
        ]
    , span
        [ class "remove" ]
        [ Utils.icon "remove" ]
    ]


rankingsBlock : (String -> Bool) -> LiveTrack -> Html
rankingsBlock isGhost { meta } =
  div
    [ class "aside-module module-rankings" ]
    [ Utils.moduleTitle "Best times"
    , ul
        [ class "list-unstyled list-rankings" ]
        (List.map (rankingItem isGhost) meta.rankings)
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
      , span [ class "status" ] [ text (Utils.formatTimer True ranking.finishTime) ]
      , span [ class "handle" ] [ text (Utils.playerHandle ranking.player) ]
      ]


helpBlock : Html
helpBlock =
  div
    [ class "aside-module module-help" ]
    [ Utils.moduleTitle "Help"
    , dl [] helpItems
    ]


helpItems : List Html
helpItems =
  [ ( "LEFT/RIGHT", "turn" )
  , ( "LEFT/RIGHT + SHIFT", "adjust" )
  , ( "ENTER", "lock angle to wind" )
  , ( "SPACE", "tack or jibe" )
  ]
    |> List.concatMap helpItem


helpItem : ( String, String ) -> List Html
helpItem ( keys, role ) =
  [ dt [] [ text keys ], dd [] [ text role ] ]
