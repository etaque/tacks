module Screens.Home.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Constants exposing (..)

import Screens.Home.Types exposing (..)
import Screens.Home.Updates exposing (addr)
import Screens.Utils exposing (..)


view : Player -> Screen -> Html
view player screen =
  div
    [ class "home" ]
    [ welcome player screen.handle
    , liveTracks player screen.liveStatus
    ]

welcome : Player -> String -> Html
welcome player handle =
  titleWrapper <| List.append
    [ h1 [] [ text ("welcome, " ++ (Maybe.withDefault "Anonymous" player.handle)) ] ]
    (welcomeForms player handle)

welcomeForms : Player -> String -> List Html
welcomeForms player handle =
  if player.guest then
    [ setHandleBlock handle ]
  else
    []

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
      , p [ class "align-center" ] [ linkTo "/login" [ ] [ text "or log in"] ]
      ]
    ]


liveTracks : Player -> LiveStatus -> Html
liveTracks player {liveTracks} =
  div [ class "container" ]
    [ div [ class "row" ] (List.map liveTrackBlock liveTracks)
    , if isAdmin player then createTrackBlock else div [] []
    ]

liveTrackBlock : LiveTrack -> Html
liveTrackBlock ({track, players} as lt) =
  div [ class "col-md-4" ]
    [ div [ class "live-track" ]
      [ linkTo ("/play/" ++ track.id)
        [ class "show"
        ]
        [ div
          [ class <| "player-count player-count-" ++ (toString (List.length players)) ]
          [ text << toString <| List.length players ]
        , span [ class "name" ] [ text track.name ]
        , div [ class "description"] [ text "TODO description" ]
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
  div [ class "row" ]
    [ p [ class "align-center"]
      [ a [ onClick addr CreateTrack
          , class "btn btn-primary" ]
        [ text "Create track" ]
      ]
    ]

