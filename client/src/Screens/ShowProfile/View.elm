module Screens.ShowProfile.View where

import Html exposing (..)
import Html.Attributes exposing (..)

import AppTypes exposing (..)
import Models exposing (..)

import Screens.ShowProfile.Types exposing (..)

import Screens.Utils exposing (..)
import Screens.Layout as Layout


view : Context -> Screen -> Html
view ctx {player} =
  Layout.layoutWithNav ctx
    [ container "show-profile"
      [ img [ class "avatar avatar-user", src (avatarUrl player), width 160, height 160 ] []
      , h1 [ ] [ text <| playerHandle player ]
      ]
    ]
