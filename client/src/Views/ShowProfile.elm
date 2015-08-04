module Views.ShowProfile where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import State exposing (..)
import Game exposing (..)
import Messages exposing (Translator)
import Inputs exposing (actionsMailbox)
import Forms.Model exposing (..)
import Forms.Update exposing (..)

import Views.Utils exposing (..)


view : Player -> Translator -> AppState -> Html
view player t state =
  div [ class "show-user"]
    [ titleWrapper
      [ container
        [ img [ class "avatar avatar-user", src (avatarUrl player), width 160, height 160 ] []
        , h1 [ ] [ text <| playerHandle player ]
        ]
      ]
    ]
