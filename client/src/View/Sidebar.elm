module View.Sidebar where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model exposing (..)
import Model.Shared exposing (..)

import View.Utils exposing (..)
import Route exposing (..)
import Page.Admin.Model as Admin
import Page.Forum.Model as Forum


view : Context -> List Html
view {player} =
  [ logo
  , div [ class "user-info" ]
    [ text "Hello, "
    , strong [ ] [ text (playerHandle player) ]
    , text "."
    ]
  ] ++ if player.guest then guestContent else (userContent player)


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
    draftsLink = li [ ] [ linkTo ListDrafts [ ] [ text "Your tracks" ] ]
    forumLink = li [ ] [ linkTo (Forum Forum.initialRoute) [ ] [ text "Forum" ] ]
    adminLink = li [ ] [ linkTo (Admin Admin.initialRoute) [ ] [ text "Admin" ] ]
  in
    [ ul [ class "user-menu" ] <|
        li [] [ linkTo Home [ ] [ text "Home" ] ]
        :: draftsLink
        :: forumLink
        :: (if isAdmin player then [ adminLink ] else [ ])
    , div [ class "logout" ]
      [ a [ onClick appActionsAddress Logout ] [ text "Logout" ] ]
    ]
