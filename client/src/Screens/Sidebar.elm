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
  logo :: if player.guest then guestContent else (userContent player)


logo : Html
logo =
  div [ class "logo" ]
  [ linkTo Home [ ]
    [ img [ src "/assets/images/logo-header-2@2x.png" ] [] ]
  ]

guestContent : List Html
guestContent =
  [ ul [ class "user-menu" ]
    [ li [] [ linkTo Home [ ] [ text "Home" ] ]
    , li [] [ linkTo Login [ ] [ text "Login" ] ]
    , li [] [ linkTo Register [ ] [ text "Register"] ]
    ]
  ]


userContent : Player -> List Html
userContent player =
  let
    draftsLink = li [ ] [ linkTo ListDrafts [ ] [ text "Drafts" ] ]
  in
    [ p [ ] [ text <| "logged in as " ++ (playerHandle player) ]
    , ul [ class "user-menu" ] <|
        li [] [ linkTo Home [ ] [ text "Home" ] ]
        :: (if isAdmin player then [ draftsLink ] else [ ])
    , div [ class "logout" ]
      [ a [ onClick appActionsAddress Logout, class "logout" ] [ text "Logout" ] ]
    ]
