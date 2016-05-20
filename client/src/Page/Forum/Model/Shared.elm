module Page.Forum.Model.Shared exposing (..)

import Time exposing (Time)

import Model.Shared exposing (Id, User)


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
