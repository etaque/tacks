module Screens.Game.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Graphics.Element as E exposing (..)
import Color exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Game.Models exposing (GameState)

import Screens.Game.Types exposing (..)
import Screens.Game.Updates exposing (actions)

import Screens.TopBar as TopBar
import Screens.Utils exposing (..)
import Game.Render.All exposing (renderGame)


view : (Int, Int) -> Screen -> Html
view dims ({track, gameState} as screen) =
  div [ class "content" ] <|
    Maybe.withDefault loading (Maybe.map (gameView dims screen) gameState)

loading : List Html
loading =
  [ titleWrapper [ h1 [] [ text "loading..." ]] ]

leftWidth = 200
rightWidth = 200

gameView : (Int, Int) -> Screen -> GameState -> List Html
gameView (w, h) screen gameState =
  [ leftBar (h - TopBar.height) gameState
  , fromElement <| renderGame (w - leftWidth - rightWidth, h - TopBar.height) gameState
  , rightBar (h - TopBar.height) screen
  ]

leftBar : Int -> GameState -> Html
leftBar h gameState =
  aside [ style [("height", toString h ++ "px")] ]
    [ playersBlock <| List.append [ gameState.playerState.player ] (List.map .player gameState.opponents)
    ]

rightBar : Int -> Screen -> Html
rightBar h screen =
  aside [ style [("height", toString h ++ "px")] ]
    [ chatBlock screen
    ]

playersBlock : List Player -> Html
playersBlock players =
  div [ class "aside-module" ]
    [ h3 [ ] [ text "Players" ]
    , ul [ class "list-unstyled list-players" ] (List.map playerItem players)
    ]


playerItem : Player -> Html
playerItem player =
  li [ class "player" ] [ playerWithAvatar player ]



chatBlock : Screen -> Html
chatBlock {messages, messageField} =
  div [ class "aside-module chat"]
    [ h3 [ ] [ text "Chat" ]
    , messagesList messages
    , chatField messageField
    ]


messagesList : List Message -> Html
messagesList messages =
  ul [ class "list-unstyled messages" ] (List.map messageItem (List.reverse messages))


messageItem : Message -> Html
messageItem {player, content, time} =
  li [ ] [ text content ]


chatField : String -> Html
chatField field =
  textInput
    [ value field
    , onInput actions.address UpdateMessageField
    , onEnter actions.address SubmitMessage
    ]
