module Screens.Home.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import Routes exposing (..)

import Screens.Home.Types exposing (..)
import Screens.Home.Updates exposing (addr)
import Screens.Utils exposing (..)


view : Player -> Screen -> Html
view player screen =
  div
    [ class "home" ]
    [ h1 [ ] [ text "Welcome to Tacks" ]
    , welcomeForm player screen.handle
    , liveTracks player screen.liveStatus
    ]

welcomeForm : Player -> String -> Html
welcomeForm player handle =
  if player.guest then
    setHandleBlock handle
  else
    div [ ] [ ]

setHandleBlock : String -> Html
setHandleBlock handle =
  div [ class "row form-set-handle" ]
    [ col4
      [ div [ class "input-group" ]
        [ textInput
          [ placeholder "Got a nickname?"
          , value handle
          -- , onInputFormUpdate (\s -> UpdateSetHandleForm (\f -> { f | handle <- s } ))
          , onInput addr SetHandle
          , onEnter addr SubmitHandle
          ]
        , span [ class "input-group-btn" ]
          [ button
            [ class "btn btn-primary"
            , onClick addr SubmitHandle
            ]
            [ text "submit" ]
          ]
        ]
      , p [ class "align-center" ] [ linkTo Login [ ] [ text "or log in"] ]
      ]
    ]


liveTracks : Player -> LiveStatus -> Html
liveTracks player {liveTracks} =
  div [ class "liveTracks" ]
    [ div [ class "row" ] (List.map liveTrackBlock liveTracks)
    , if isAdmin player then createTrackBlock else div [] []
    ]

liveTrackBlock : LiveTrack -> Html
liveTrackBlock ({track, players} as lt) =
  div [ class "col-md-4" ]
    [ div [ class "live-track" ]
      [ linkTo (PlayTrack track.id)
        [ class "show"
        ]
        [ h3 [ class "name" ] [ text track.name ]
        , div [ class "description"] [ text track.creatorId ]
        , playersList players
        ]
      ]
    ]

playersList : List Player -> Html
playersList players =
  ul [ class "list-unstyled track-players" ] (List.map playerItem players)

playerItem : Player -> Html
playerItem player =
  li [ class "player" ] [ playerWithAvatar player ]

createTrackBlock : Html
createTrackBlock =
  p [ class "" ]
    [ a [ onClick addr CreateTrack
        , class "btn btn-primary" ]
      [ text "Create track" ]
    ]

