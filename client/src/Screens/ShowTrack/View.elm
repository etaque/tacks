module Screens.ShowTrack.View where

import Html exposing (..)
import Html.Attributes exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Routes exposing (..)

import Screens.ShowTrack.Types exposing (..)

import Screens.Utils exposing (..)
import Screens.Layout as Layout


view : Context -> Screen -> Html
view ctx {track} =
  Layout.layoutWithNav "show-track" ctx
    [ container ""
      [ Maybe.withDefault loading (Maybe.map withTrack track)
      ]
    ]

loading : Html
loading =
  h1 [] [ text "loading..." ]

withTrack : Track -> Html
withTrack track =
  div []
    [ h1 [] [ text <| track.id ]
    , joinButton track
    ]

joinButton : Track -> Html
joinButton track =
  linkTo (PlayTrack track.id)
    [ class "btn btn-warning join-track"]
    [ text "Join"]
