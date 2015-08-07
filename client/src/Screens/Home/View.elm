module Screens.Home.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)

import Screens.Home.Types exposing (..)
import Screens.Home.Updates exposing (actions)

import Views.Utils exposing (..)


view : Player -> Screen -> Html
view player screen =
  div [ class "home"]
    [ welcome player screen.handle
    , liveTracks screen.liveStatus
    ]

welcome : Player -> String -> Html
welcome player handle =
  titleWrapper <| List.append
    [ h1 [] [ text ("Welcome, " ++ (Maybe.withDefault "Anonymous" player.handle)) ] ]
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
          , onInput actions.address SetHandle
          , onEnter actions.address SubmitHandle
          ]
        , span [ class "input-group-btn" ]
          [ button
            [ class "btn btn-primary"
            , onClick actions.address SubmitHandle
            ]
            [ text "submit" ]
          ]
        ]
      , p [ class "align-center" ] [ a [ path "/login" ] [ text "or log in"] ]
      ]
    ]


liveTracks : LiveStatus -> Html
liveTracks {liveTracks} =
  div [ class "container" ]
    [ div [ class "row" ] [ p [ class "align-center upclassic" ] [ text "Choose your track" ] ]
    , div [ class "row" ] (List.map liveTrackBlock liveTracks)
    ]

liveTrackBlock : LiveTrack -> Html
liveTrackBlock ({track, players} as lt) =
  div [ class "col-md-4" ]
    [ div [ class "live-track" ]
      [ a
        [ class "show"
        , style [ ("background-image", "url(/assets/images/trials-" ++ track.slug ++ ".png)") ]
        , path ("/track/" ++ track.slug)
        ]
        [ span [ class "name" ] [ text track.slug ]
        , div [ class "description"] [ text track.slug ]
        ]
      , playersList players
      ]
    ]

playersList : List Player -> Html
playersList players =
  ul [ class "track-players" ] (List.map playerItem players)

playerItem : Player -> Html
playerItem player =
  li [ class "player" ] [ playerWithAvatar player ]

