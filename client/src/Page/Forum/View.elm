module Page.Forum.View where

import Signal exposing (Address)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model.Shared exposing (Context)

import Page.Forum.Route exposing (..)
import Page.Forum.Model exposing (..)
import Page.Forum.Update exposing (addr)
import Page.Forum.Index.View as Index
import Page.Forum.ShowTopic.View as ShowTopic
import Page.Forum.NewTopic.View as NewTopic

import View.Utils exposing (..)
import View.Layout as Layout


view : Context -> Route -> Model -> Html
view ctx route model =
  let
    subView =
      case route of
        Index ->
          Index.view (Signal.forwardTo addr IndexAction) model.index
        ShowTopic _ ->
          ShowTopic.view (Signal.forwardTo addr ShowTopicAction) model.showTopic
        NewTopic ->
          NewTopic.view (Signal.forwardTo addr NewTopicAction) model.newTopic
  in
    Layout.siteLayout "forum" ctx Nothing subView
