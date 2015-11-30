module Screens.Sidebar where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)

import Screens.Utils exposing (..)
import Constants exposing (..)


view : Player -> Html
view player =
  aside
    [ style [ ("width", toString sidebarWidth ++ "px") ] ]
    [ logo
    , mainMenu player
    ]


logo : Html
logo =
  div [ class "logo" ]
    [ linkTo "/" [ ]
      [ img [ src "/assets/images/logo-header-2.png" ] [] ]
    ]


mainMenu : Player -> Html
mainMenu player =
  let
    playerItems = if player.guest then guestItems else userItems player
    allItems =
      [ li [ ] [ linkTo "/" [ ] [ text "Home" ] ]
      ] ++ playerItems
  in
    ul [ class "user-menu" ] allItems


guestItems : List Html
guestItems =
  [ li [] [ linkTo "/login" [ ] [ text "Login" ] ]
  , li [] [ linkTo "/register" [ ] [ text "Register"] ]
  ]


userItems : Player -> List Html
userItems player =
  [ li [] [ linkTo "/me" [ ] [ text "Profile" ] ]
  , li [] [ a [ onClick appActionsMailbox.address Logout ] [ text "Logout"] ]
  ]

