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
  nav [ ]
    [ logo
    , (playerMenu appState.player)
    ]

logo : Html
logo =
  div [ class "logo" ]
    [ linkTo "/" [ ]
      [ img [ src "/assets/images/logo-header-2.png" ] [] ]
    ]

playerMenu : Player -> Html
playerMenu player =
  if player.guest then
    guestMenu
  else
    userMenu player

guestMenu : Html
guestMenu =
  ul [ class "user-menu" ]
    [ li [ ]
      [ linkTo "/login" [ ] [ text "Login" ] ]
    , li [ ]
      [ linkTo "/register" [ ] [ text "Register"] ]
    ]

userMenu : Player -> Html
userMenu player =
  ul [ class "user-menu" ]
    [ li [ ]
      [ linkTo "/me" [ ]
        [ img [ src (avatarUrl player), class "avatar avatar-user" ] [ ]
        , text "Profile"
        ]
      ]
    , li [ ]
      [ a [ onClick actionsMailbox.address Logout ] [ text "Logout"] ]
    ]
