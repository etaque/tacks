module Page.Forum.Model where

import Page.Forum.Route exposing (..)
import Page.Forum.Index.Model as Index
import Page.Forum.NewTopic.Model as NewTopic
import Page.Forum.ShowTopic.Model as ShowTopic


type alias Model =
  { index : Index.Model
  , showTopic : ShowTopic.Model
  , newTopic : NewTopic.Model
  }


initialRoute : Route
initialRoute =
  Index


initial : Model
initial =
  { index = Index.initial
  , newTopic = NewTopic.initial
  , showTopic = ShowTopic.initial
  }


type Action
  = IndexAction Index.Action
  | NewTopicAction NewTopic.Action
  | ShowTopicAction ShowTopic.Action
  | NoOp

