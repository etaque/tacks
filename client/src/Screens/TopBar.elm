module Screens.TopBar where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Screens.Utils exposing (..)
import Models exposing (..)
import AppTypes exposing (..)
import AppUpdates exposing (actionsMailbox)


height = 50
logoWidth = 160

view : AppState -> Html
view appState =
  nav [ class "navbar" ]
    [ div [ class "container" ]
        [ logo
        , (playerMenu appState.player)
        ]
    ]

logo : Html
logo =
  div [ class "navbar-header" ]
    [ a [ class "navbar-brand", path "/" ]
      [ img [ src "/assets/images/logo-header-2.png", class "logo" ] [] ]
    ]

playerMenu : Player -> Html
playerMenu player =
  if player.guest then
    guestMenu
  else
    userMenu player

guestMenu : Html
guestMenu =
  ul [ class "nav navbar-nav navbar-right nav-user" ]
    [ li [ ]
      [ a [ path "/login" ] [ text "Login" ] ]
    , li [ ]
      [ a [ path "/register" ] [ text "Register"] ]
    ]

userMenu : Player -> Html
userMenu player =
  ul [ class "nav navbar-nav navbar-right nav-user" ]
    [ li [ ]
      [ a [ path "/me"]
        [ img [ src (avatarUrl player), class "avatar avatar-user" ] [ ]
        , text "Profile"
        ]
      ]
    , li [ ]
      [ a [ onClick actionsMailbox.address Logout ] [ text "Logout"] ]
    ]
