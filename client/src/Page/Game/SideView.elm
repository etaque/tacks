module Page.Game.SideView where

import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (..)
import Game.Models exposing (GameState)

import Page.Game.Model exposing (..)
import Page.Game.PlayersView as PlayersView
import Page.Sidebar as Sidebar

import Page.Utils exposing (..)
import Route exposing (..)


view : Screen -> LiveTrack -> GameState -> List Html
view screen liveTrack gameState =
  let
    blocks =
      if liveTrack.track.status == Draft then
        draftBlocks liveTrack
      else
        liveBlocks screen liveTrack
  in
    Sidebar.logo :: (trackNav liveTrack) :: blocks


trackNav : LiveTrack -> Html
trackNav liveTrack =
  div [ class "track-menu" ]
    [ hr'
    , h2 [] [ text liveTrack.track.name ]
    , hr'
    ]


draftBlocks : LiveTrack -> List Html
draftBlocks {track} =
  [ p [ class "draft-warning" ]
    [ text "This is a draft, you're the only one seeing this race track." ]
  , div [ class "form-actions" ]
    [ linkTo (EditTrack track.id) [ class "btn btn-block btn-primary" ]
      [ text "Edit draft" ]
    ]
  ]


liveBlocks : Screen -> LiveTrack -> List Html
liveBlocks screen liveTrack =
  [ PlayersView.block screen
  , rankingsBlock liveTrack
  , helpBlock
  ]


rankingsBlock : LiveTrack -> Html
rankingsBlock {meta} =
  div [ class "aside-module module-rankings" ]
    [ moduleTitle "Best times"
    , ul [ class "list-unstyled list-rankings" ] (List.map rankingItem meta.rankings)
    ]


helpBlock : Html
helpBlock =
  div [ class "aside-module module-help" ]
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

