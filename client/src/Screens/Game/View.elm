module Screens.Game.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Graphics.Element as E exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Game.Models exposing (GameState)

import Screens.Game.Types exposing (..)
import Screens.Game.Updates exposing (actions)
import Screens.Game.ChatView exposing (chatBlock)
import Screens.Game.PlayersView exposing (playersBlock)

import Screens.TopBar as TopBar
import Screens.Utils exposing (..)
import Game.Render.All exposing (renderGame)
import Game.Render.All2 exposing (renderSvg)


view : (Int, Int) -> Screen -> Html
view dims ({liveTrack, gameState} as screen) =
  div [ class "content" ] <|
    Maybe.withDefault loading (Maybe.map (gameView dims screen) gameState)

loading : List Html
loading =
  [ titleWrapper [ h1 [] [ text "loading..." ]] ]

leftWidth = 240
rightWidth = 200

gameView : (Int, Int) -> Screen -> GameState -> List Html
gameView (w, h) screen gameState =
  let
    -- gameElement = renderGame (w - leftWidth - rightWidth, h - TopBar.height) gameState
    gameSvg = renderSvg (w - leftWidth - rightWidth, h - TopBar.height) gameState
  in
    [ leftBar (h - TopBar.height) screen gameState
    -- , div [ class "game" ] [ fromElement gameElement ]
    , div [ class "game" ] [ gameSvg ]
    , rightBar (h - TopBar.height) screen gameState
    ]

leftBar : Int -> Screen -> GameState -> Html
leftBar h screen gameState =
  aside [ style [("height", toString h ++ "px")] ]
    [ playersBlock screen
    , chatBlock screen
    , helpBlock
    ]

rightBar : Int -> Screen -> GameState -> Html
rightBar h screen gameState =
  aside [ style [("height", toString h ++ "px")] ]
    [ Maybe.map rankingsBlock screen.liveTrack |> Maybe.withDefault (div [ ] [ ])
    ]

rankingsBlock : LiveTrack -> Html
rankingsBlock {rankings} =
  div [ class "aside-module module-rankings" ]
    [ h4 [ ] [ text "Best times" ]
    , ul [ class "list-unstyled list-rankings" ] (List.map rankingItem rankings)
    ]

rankingItem : Ranking -> Html
rankingItem ranking =
  li [ class "ranking" ]
    [ span [ class "position" ] [ text (toString ranking.rank)]
    , span [ class "handle" ] [ text (playerHandle ranking.player) ]
    , span [ class "time" ] [ text (formatTimer True ranking.finishTime) ]
    -- , playerWithAvatar ranking.player
    ]

helpBlock : Html
helpBlock =
  div [ class "aside-module module-help" ]
    [ h3 [ ] [ text "Help" ]
    , dl [ ] helpItems
    ]

helpItems : List Html
helpItems =
  List.concatMap (\(dt', dd') -> [ dt [ ] [ text dt' ], dd [ ] [ text dd'] ]) <|
    [ ("ARROWS", "turn left/right")
    , ("ARROWS + ⇧", "adjust left/right")
    , ("⏎", "lock angle to wind")
    , ("SPACE", "tack or jibe")
    , ("ESC", "quit race")
    ]

