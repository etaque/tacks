module Page.Forum.View where

import Signal exposing (Address)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model.Shared exposing (Context)
import Route

import Page.Forum.Route exposing (..)
import Page.Forum.Model exposing (..)
import Page.Forum.Update exposing (addr)
import Page.Forum.View.Index as Index
import Page.Forum.View.ShowTopic as ShowTopic

import View.Utils exposing (..)
import View.Layout as Layout


view : Context -> Route -> Model -> Html
view ctx route model =
  let
    subView =
    case route of
      Index ->
        Index.view model
      ShowTopic _ ->
        ShowTopic.view model
  in
    Layout.layoutWithNav "forum" ctx [ subView ]
