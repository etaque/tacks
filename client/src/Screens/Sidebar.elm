module Screens.Sidebar where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)

import Screens.Utils exposing (..)
import Routes exposing (..)


view : Context -> List Html
view {player} =
  [ logo
  , mainMenu player
  ]


logo : Html
logo =
  div [ class "logo" ] []
    -- [ linkTo Home [ ]
    --   [ img [ src "/assets/images/logo-header-2.png" ] [] ]
    -- ]


mainMenu : Player -> Html
mainMenu player =
  let
    playerItems = if player.guest then guestItems else userItems player
    allItems =
      [ li [ ] [ linkTo Home [ ] [ text "Home" ] ]
      ] ++ playerItems
  in
    ul [ class "user-menu" ] allItems


guestItems : List Html
guestItems =
  [ li [] [ linkTo Login [ ] [ text "Login" ] ]
  , li [] [ linkTo Register [ ] [ text "Register"] ]
  ]


userItems : Player -> List Html
userItems player =
  [ li [] [ linkTo ShowProfile [ ] [ text "Profile" ] ]
  , li [] [ a [ onClick appActionsAddress Logout ] [ text "Logout"] ]
  ]

