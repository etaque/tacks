module Views.TopBar where

import Graphics.Element exposing (..)
import Graphics.Input exposing (..)

import State exposing (..)
import Messages exposing (Translator)
import Inputs exposing (navigate)


height = 80
logoWidth = 160

view : Translator -> Int -> AppState -> Element
view t width appState =
  flow right
    [ logo
    ]

logo : Element
logo =
  let
    msg = navigate Home
    img = image logoWidth height "/assets/images/logo-header-2.png"
  in
    customButton msg img img img
