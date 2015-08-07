module Screens.ShowTrack.ShowTrackView where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)

import Screens.ShowTrack.ShowTrackTypes exposing (..)
import Screens.ShowTrack.ShowTrackUpdates exposing (actions)

import Views.Utils exposing (..)


view : Screen -> Html
view {track} =
  div [ class "show-track" ]
    [ Maybe.withDefault loading (Maybe.map withTrack track)
    ]

loading : Html
loading =
  titleWrapper [ h1 [] [ text "loading..." ]]

withTrack : Track -> Html
withTrack track =
  titleWrapper
    [ h1 [] [ text <| track.slug ]
    , joinButton track
    ]

joinButton : Track -> Html
joinButton track =
  a
    [ class "btn btn-warning join-track"
    , path ("/play/" ++ track.slug)
    ] [ text "Join"]
