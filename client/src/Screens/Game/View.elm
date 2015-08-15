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
  [ leftBar (h - TopBar.height) screen gameState
  , fromElement <| renderGame (w - leftWidth, h - TopBar.height) gameState
  -- , rightBar (h - TopBar.height) screen gameState
  ]

leftBar : Int -> Screen -> GameState -> Html
leftBar h screen gameState =
  aside [ style [("height", toString h ++ "px")] ]
    [ playersBlock <| List.append [ gameState.playerState.player ] (List.map .player gameState.opponents)
    , chatBlock screen
    -- [ bestTimesBlock
    , helpBlock
    ]

rightBar : Int -> Screen -> GameState -> Html
rightBar h screen gameState =
  aside [ style [("height", toString h ++ "px")] ]
    [ playersBlock <| List.append [ gameState.playerState.player ] (List.map .player gameState.opponents)
    , chatBlock screen
    ]

bestTimesBlock : Html
bestTimesBlock =
  div [ class "aside-module module-best-times" ]
    [ h3 [ ] [ text "Best times" ]
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


playersBlock : List Player -> Html
playersBlock players =
  div [ class "aside-module module-players" ]
    [ ul [ class "list-unstyled list-players" ] (List.map playerItem players)
    ]


playerItem : Player -> Html
playerItem player =
  li [ class "player" ] [ playerWithAvatar player ]



chatBlock : Screen -> Html
chatBlock {messages, messageField} =
  div [ class "aside-module module-chat"]
    [ div [ class "messages" ] [ messagesList messages ]
    , chatField messageField
    ]


messagesList : List Message -> Html
messagesList messages =
  ul [ class "list-unstyled" ] (List.map messageItem (List.reverse messages))


messageItem : Message -> Html
messageItem {player, content, time} =
  li [ ]
    [ span [ class "message-handle" ] [ text <| playerHandle player ]
    , span [ class "message-content" ] [ text content ]
    ]


chatField : String -> Html
chatField field =
  textInput
    [ value field
    , onInput actions.address UpdateMessageField
    , onEnter actions.address SubmitMessage
    , onFocus actions.address EnterChat
    , onBlur actions.address LeaveChat
    ]
