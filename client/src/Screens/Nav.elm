module Screens.Nav where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Screens.Utils exposing (..)
import Models exposing (..)
import AppTypes exposing (..)
import Routes exposing (..)


logoWidth : Int
logoWidth =
  160

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
    [ linkTo Home [ ] [ img [ src "/assets/images/logo-header-2.svg" ] [] ] ]

playerMenu : Player -> Html
playerMenu player =
  div [ class "col-md-6"]
    [ ul
      [ class "player-menu" ]
      ([ li [] [ linkTo Home [] [ text "Home" ] ]
       ] ++ if player.guest then guestMenu else userMenu)
    ]

guestMenu : List Html
guestMenu =
    [ li [] [ linkTo Login [] [ text "Login" ] ]
    , li [] [ linkTo Register [] [ text "Register"] ]
    ]

userMenu : List Html
userMenu =
    [ li [] [ linkTo ShowProfile [] [ text "Profile" ] ]
    , li [] [ a [ onClick appActionsAddress Logout ] [ text "Logout"] ]
    ]
