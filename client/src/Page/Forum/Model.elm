module Page.Forum.Model where

import Model.Shared exposing (..)
import Model.Forum exposing (..)
import Page.Forum.Route exposing (..)


type alias Model =
  { topics : List Topic
  , currentTopic : Maybe Topic
  }

initialRoute : Route
initialRoute =
  Index

initial : Model
initial =
  { topics = []
  , currentTopic = Nothing
  }

type Action
  = TopicsResult (Result () (List Topic))
  | NoOp

