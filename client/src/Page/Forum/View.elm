module Page.Forum.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model exposing (..)
import Model.Shared exposing (..)

import Page.Forum.Route exposing (..)
import Page.Forum.Model exposing (..)
import Page.Forum.Update exposing (addr)

import View.Utils exposing (..)
import View.Layout as Layout


view : Context -> Route -> Screen -> Html
view ctx route screen =
  Layout.layoutWithNav "forum" ctx
    [ text "TODO" ]
