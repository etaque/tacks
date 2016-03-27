module Page.Game.SideView (..) where

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Game.Models exposing (GameState)
import Game.Outputs as Outputs
import Page.Game.Model exposing (..)
import Page.Game.Update exposing (addr)
import Page.Game.PlayersView as PlayersView
import View.Sidebar as Sidebar
import View.Utils exposing (..)
import Route exposing (..)


view : Model -> LiveTrack -> GameState -> List Html
view model liveTrack gameState =
  let
    blocks =
      if liveTrack.track.status == Draft then
        draftBlocks liveTrack
      else
        liveBlocks model liveTrack
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
      [ linkTo
          (EditTrack track.id)
          [ class "btn btn-block btn-primary" ]
          [ text "Edit draft" ]
      ]
  ]


liveBlocks : Model -> LiveTrack -> List Html
liveBlocks model liveTrack =
  [ PlayersView.block model
  , a [ onClick Outputs.serverAddress Outputs.StartRace ] [ text "Start race" ]
  -- , ghostsBlock model.ghostRuns
  , rankingsBlock (\runId -> Dict.member runId model.ghostRuns) liveTrack
  , helpBlock
  ]


ghostsBlock : Dict String Player -> Html
ghostsBlock ghostRuns =
  div
    [ class "aside-module module-ghosts" ]
    [ moduleTitle "Ghosts"
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
    [ onClick addr (RemoveGhost runId) ]
    [ span [ class "handle" ] [ text (playerHandle player) ] ]


rankingsBlock : (String -> Bool) -> LiveTrack -> Html
rankingsBlock isGhost { meta } =
  div
    [ class "aside-module module-rankings" ]
    [ moduleTitle "Best times"
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
      , span [ class "status" ] [ text (formatTimer True ranking.finishTime) ]
      , span [ class "handle" ] [ text (playerHandle ranking.player) ]
      ]


helpBlock : Html
helpBlock =
  div
    [ class "aside-module module-help" ]
    [ moduleTitle "Help"
    , dl [] helpItems
    ]


helpItems : List Html
helpItems =
  [ ( "LEFT/RIGHT", "turn" )
  , ( "LEFT/RIGHT + SHIFT", "adjust" )
  , ( "ENTER", "lock angle to wind" )
  , ( "SPACE", "tack or jibe" )
  , ( "ESC", "quit race" )
  ]
    |> List.concatMap helpItem


helpItem : ( String, String ) -> List Html
helpItem ( keys, role ) =
  [ dt [] [ text keys ], dd [] [ text role ] ]
