module Screens.ShowProfile where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)

import Screens.Utils exposing (..)


view : Player -> AppState -> Html
view player state =
  div [ class "show-user"]
    [ titleWrapper
      [ container
        [ img [ class "avatar avatar-user", src (avatarUrl player), width 160, height 160 ] []
        , h1 [ ] [ text <| playerHandle player ]
        ]
      ]
    ]
