module Screens.Game.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Game.Models exposing (GameState)

import Screens.Game.Types exposing (..)
import Screens.Game.Updates exposing (actions)
import Screens.Game.ChatView exposing (chatBlock)
import Screens.Game.PlayersView exposing (playersBlock)

import Screens.Utils exposing (..)
import Game.Render.All exposing (render)
import Constants exposing (..)


view : Dims -> Screen -> Html
view dims ({liveTrack, gameState} as screen) =
  div [ class "content" ] <|
    Maybe.withDefault loading (Maybe.map (gameView dims screen) gameState)

loading : List Html
loading =
  [ text "loading..." ]

gameView : Dims -> Screen -> GameState -> List Html
gameView (w, h) screen gameState =
  let
    gameSvg = render (w - sidebarWidth, h) gameState
  in
    [ leftBar h screen gameState
    , div [ class "game" ] [ gameSvg ]
    , chatBlock h screen
    ]

leftBar : Int -> Screen -> GameState -> Html
leftBar h screen gameState =
  sidebar (sidebarWidth, h)
    [ withLiveTrack trackNav screen.liveTrack
    , playersBlock screen
    -- , chatBlock screen
    , withLiveTrack rankingsBlock screen.liveTrack
    , helpBlock
    ]

trackNav : LiveTrack -> Html
trackNav liveTrack =
  div [ class "track-menu" ]
    [ h2 [ ] [ text liveTrack.track.slug ]
    , linkTo "/" [ class "btn btn-xs btn-default" ] [ text "Exit" ]
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
  List.concatMap helpItem <|
    [ ("LEFT/RIGHT", "turn")
    , ("LEFT/RIGHT + SHIFT", "adjust")
    , ("ENTER", "lock angle to wind")
    , ("SPACE", "tack or jibe")
    , ("ESC", "quit race")
    ]

helpItem : (String, String) -> List Html
helpItem (keys, role) =
  [ dt [ ] [ text keys ], dd [ ] [ text role ] ]

withLiveTrack : (LiveTrack -> Html) -> Maybe LiveTrack -> Html
withLiveTrack f maybeLiveTrack =
  Maybe.map f maybeLiveTrack |> orEmptyDiv

orEmptyDiv =
  Maybe.withDefault emptyDiv

emptyDiv = div [ ] [ ]
