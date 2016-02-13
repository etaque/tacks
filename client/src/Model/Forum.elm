module Model.Forum where

import Time exposing (Time)

type alias UUID = String

type alias ForumPost =
  { id : UUID
  , title : Maybe String
  , parentId : Maybe UUID
  , userId : UUID
  , content : String
  , creationTime : Time
  , updateTime : Time
  }
