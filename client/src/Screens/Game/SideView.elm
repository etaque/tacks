module Screens.Game.SideView where

import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (..)
import Game.Models exposing (GameState)

import Screens.Game.Types exposing (..)
import Screens.Game.PlayersView as PlayersView

import Screens.Utils exposing (..)
import Constants exposing (..)


view : Int -> Screen -> LiveTrack -> GameState -> Html
view h screen liveTrack gameState =
  let
    blocks =
      if liveTrack.track.draft then
        draftBlocks liveTrack
      else
        liveBlocks screen liveTrack
  in
    sidebar (sidebarWidth, h) ((trackNav liveTrack) :: blocks)


trackNav : LiveTrack -> Html
trackNav liveTrack =
  div [ class "track-menu" ]
    [ h2 [ ] [ text liveTrack.track.name ]
    , linkTo "/" [ class "btn btn-xs btn-default" ] [ text "Exit" ]
    ]


draftBlocks : LiveTrack -> List Html
draftBlocks {track} =
  [ p [ class "draft-warning" ]
      [ text "This is a draft, you're the only one seeing this race track." ]
  , linkTo ("/edit/" ++ track.id) [ class "btn btn-block btn-primary" ]
      [ text "Edit race track" ]
  ]


liveBlocks : Screen -> LiveTrack -> List Html
liveBlocks screen liveTrack =
  [ PlayersView.block screen
  , rankingsBlock liveTrack
  , helpBlock
  ]


rankingsBlock : LiveTrack -> Html
rankingsBlock {rankings} =
  div [ class "aside-module module-rankings" ]
    [ h3 [ ] [ text "Best times" ]
    , ul [ class "list-unstyled list-rankings" ] (List.map rankingItem rankings)
    ]


rankingItem : Ranking -> Html
rankingItem ranking =
  li [ class "ranking" ]
    [ span [ class "rank" ] [ text (toString ranking.rank)]
    , span [ class "status" ] [ text (formatTimer True ranking.finishTime) ]
    , playerWithAvatar ranking.player
    ]


helpBlock : Html
helpBlock =
  div [ class "aside-module module-help" ]
    [ h3 [ ] [ text "Help" ]
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


emptyDiv = div [ ] [ ]



