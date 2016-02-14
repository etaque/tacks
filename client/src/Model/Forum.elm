module Model.Forum where

import Time exposing (Time)
import Model.Shared exposing (..)



type alias Topic =
  { initial : Message
  , title : String
  , messagesCount : Int
  , activityTime : Time
  }


type alias Message =
  { id : String
  , content : String
  , user : User
  , creationTime : Time
  , updateTime : Time
  }


type alias TopicWithMessages =
  { topic : Topic
  , messages : List Message
  }


-- type alias Post =
--   { id : UUID
--   , title : Maybe String
--   , parentId : Maybe UUID
--   , userId : UUID
--   , content : String
--   , creationTime : Time
--   , updateTime : Time
--   }
