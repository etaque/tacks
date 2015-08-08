module Screens.ShowProfile.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)

import Screens.ShowProfile.Types exposing (..)
import Screens.ShowProfile.Updates exposing (actions)

import Screens.Utils exposing (..)


view : Screen -> Html
view {player} =
  div [ class "show-user"]
    [ titleWrapper
      [ container
        [ img [ class "avatar avatar-user", src (avatarUrl player), width 160, height 160 ] []
        , h1 [ ] [ text <| playerHandle player ]
        ]
      ]
    ]
