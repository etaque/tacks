module Page.Game.SideView where

import Html exposing (..)
import Html.Attributes exposing (..)

import Model.Shared exposing (..)
import Game.Models exposing (GameState)

import Page.Game.Model exposing (..)
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
draftBlocks {track} =
  [ p
      [ class "draft-warning" ]
      [ text "This is a draft, you're the only one seeing this race track." ]
  , div
      [ class "form-actions" ]
      [ linkTo (EditTrack track.id) [ class "btn btn-block btn-primary" ]
          [ text "Edit draft" ]
      ]
  ]


liveBlocks : Model -> LiveTrack -> List Html
liveBlocks model liveTrack =
  [ PlayersView.block model
  , rankingsBlock liveTrack
  , helpBlock
  ]


rankingsBlock : LiveTrack -> Html
rankingsBlock {meta} =
  div
    [ class "aside-module module-rankings" ]
    [ moduleTitle "Best times"
    , ul [ class "list-unstyled list-rankings" ] (List.map rankingItem meta.rankings)
    ]


helpBlock : Html
helpBlock =
  div
    [ class "aside-module module-help" ]
    [ moduleTitle "Help"
    , dl [ ] helpItems
    ]


helpItems : List Html
helpItems =
  [ ("LEFT/RIGHT", "turn")
  , ("LEFT/RIGHT + SHIFT", "adjust")
  , ("ENTER", "lock angle to wind")
  , ("SPACE", "tack or jibe")
  , ("ESC", "quit race")
  ]
  |> List.concatMap helpItem


helpItem : (String, String) -> List Html
helpItem (keys, role) =
  [ dt [ ] [ text keys ], dd [ ] [ text role ] ]

