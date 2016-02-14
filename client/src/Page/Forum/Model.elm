module Page.Forum.Model where

import Time exposing (Time)

import Model.Shared exposing (Id, User, FormResult)
import Page.Forum.Route exposing (..)


type alias Model =
  { topics : List TopicWithUser
  , currentTopic : Maybe TopicWithPosts
  , newTopic : Maybe NewTopic
  }

type alias TopicWithUser =
  { topic : Topic, user : User }

type alias Topic =
  { id : Id
  , title : String
  , postsCount : Int
  , creationTime : Time
  , activityTime : Time
  }

type alias PostWithUser =
  { post : Post, user : User }

type alias Post =
  { id : Id
  , content : String
  , creationTime : Time
  , updateTime : Time
  }


type alias TopicWithPosts =
  { topic : Topic
  , postsWithUsers : List PostWithUser
  }


type alias NewTopic =
  { title : String
  , content : String
  }


initialRoute : Route
initialRoute =
  Index


initial : Model
initial =
  { topics = []
  , currentTopic = Nothing
  , newTopic = Nothing
  }


type Action
  = ListResult (Result () (List TopicWithUser))
  | ShowResult (Result () (TopicWithPosts))
  | RefreshList
  | ShowNewTopic
  | HideNewTopic
  | NewTopicAction NewTopicAction
  | NoOp


type NewTopicAction
  = SetTitle String
  | SetContent String
  | Submit
  | SubmitResult (FormResult Topic)
