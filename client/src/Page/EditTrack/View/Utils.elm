module Page.EditTrack.View.Utils (..) where

import Signal
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import View.Utils as Utils exposing (..)
import Page.EditTrack.Update exposing (..)
import Page.EditTrack.Model exposing (..)


formAddr : Signal.Address FormUpdate
formAddr =
  Signal.forwardTo addr FormAction


intInput : number -> (Int -> FormUpdate) -> List Attribute -> Html
intInput val formUpdate attrs =
  textInput
    ([ value (toString val)
     , onIntInput formAddr formUpdate
     , type' "number"
     ]
      ++ attrs
    )
