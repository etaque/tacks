module Views.TopBar where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Views.Utils exposing (..)

import State exposing (..)
import Messages exposing (Translator)


height = 80
logoWidth = 160

view : Translator -> AppState -> Html
view t appState =
  nav [ class "navbar" ]
    [ div [ class "container" ]
        [ logo ]
    ]

logo : Html
logo =
  div [ class "navbar-header" ]
    [ a [ class "navbar-brand", clickTo Home ]
      [ img [ src "/assets/images/logo-header-2.png", class "logo" ] [] ]
    ]

