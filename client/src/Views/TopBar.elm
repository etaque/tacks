module Views.TopBar where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Views.Utils exposing (..)
import State exposing (..)
import Game exposing (Player)
import Messages exposing (Translator)
import Forms.Model as Forms
import Forms.Update exposing (submitMailbox)


height = 50
logoWidth = 160

view : Translator -> AppState -> Html
view t appState =
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
      [ a [ ]
        [ img [ src (avatarUrl player), class "avatar avatar-user" ] [ ]
        , a [ path "/me" ] [ text "Profile" ]
        ]
      ]
    , li [ ]
      [ a [ onClick submitMailbox.address Forms.SubmitLogout ] [ text "Logout"] ]
    ]

