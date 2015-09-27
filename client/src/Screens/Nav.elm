module Screens.Nav where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Screens.Utils exposing (..)
import Models exposing (..)
import AppTypes exposing (..)
import AppUpdates exposing (actionsMailbox)


logoWidth = 160

view : AppState -> Html
view appState =
  nav [ ]
    [ div [ class "container" ]
      [ div [ class "row" ]
        [ logo
        , (playerMenu appState.player)
        ]
      ]
    ]

logo : Html
logo =
  div [ class "col-md-6 logo" ]
    [ linkTo "/" [ ] [ img [ src "/assets/images/logo-header-2.svg" ] [] ] ]

playerMenu : Player -> Html
playerMenu player =
  div [ class "col-md-6"]
    [ ul
      [ class "player-menu" ]
      ([ li [] [ linkTo "/" [] [ text "Home" ] ]
       ] ++ if player.guest then guestMenu else userMenu)
    ]

guestMenu : List Html
guestMenu =
    [ li [] [ linkTo "/login" [] [ text "Login" ] ]
    , li [] [ linkTo "/register" [] [ text "Register"] ]
    ]

userMenu : List Html
userMenu =
    [ li [] [ linkTo "/me" [] [ text "Profile" ] ]
    , li [] [ a [ onClick actionsMailbox.address Logout ] [ text "Logout"] ]
    ]
