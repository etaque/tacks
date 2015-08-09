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
  div [ class "show-track" ]
    [ Maybe.withDefault loading (Maybe.map (gameView dims screen) gameState) ]

loading : Html
loading =
  titleWrapper [ h1 [] [ text "loading..." ]]

leftWidth = 200
rightWidth = 200

gameView : (Int, Int) -> Screen -> GameState -> Html
gameView (w, h) screen gameState =
  let
    elements =
      [ leftBar (leftWidth, h) gameState
      , renderGame (w - leftWidth - rightWidth, h - TopBar.height) gameState
      , rightBar (rightWidth, h) screen
      ]
  in
    flow right elements |> fromElement

leftBar : (Int, Int) -> GameState -> Element
leftBar (w, h) gameState =
  let
    blocks =
      [ playersBlock (w, 300) <| List.append [ gameState.playerState.player ] (List.map .player gameState.opponents) ]
  in
    flow down blocks
      |> E.container w h topLeft
      |> color black

rightBar : (Int, Int) -> Screen -> Element
rightBar (w, h) screen =
  let
    blocks =
      [ chatBlock (w, h) screen
      ]
  in
    flow down blocks
      |> E.container w h topLeft
      |> color black

playersBlock : (Int, Int) -> List Player -> Element
playersBlock (w, h) players =
  div [ class "side-module" ]
    [ h3 [ ] [ text "Players" ]
    , ul [ class "list-unstyled players" ] (List.map playerItem players)
    ]
    |> toElement w h


playerItem : Player -> Html
playerItem player =
  li [ class "player" ] [ playerWithAvatar player ]



chatBlock : (Int, Int) -> Screen -> Element
chatBlock (w, h) {messages, messageField} =
  div [ class "side-module"]
    [ h3 [ ] [ text "Chat" ]
    , messagesList messages
    , chatField messageField
    ]
    |> toElement w h


messagesList : List Message -> Html
messagesList messages =
  ul [ class "messages" ] (List.map messageItem messages)


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
