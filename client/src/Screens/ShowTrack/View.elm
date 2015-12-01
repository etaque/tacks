module Screens.ShowTrack.View where

import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (..)
import Routes exposing (..)

import Screens.ShowTrack.Types exposing (..)

import Screens.Utils exposing (..)


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
    [ h1 [] [ text <| track.id ]
    , joinButton track
    ]

joinButton : Track -> Html
joinButton track =
  linkTo (PlayTrack track.id)
    [ class "btn btn-warning join-track"]
    [ text "Join"]
