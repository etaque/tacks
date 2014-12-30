module Messages where

import Dict
import Maybe as M

type alias Messages = Dict.Dict String String

emptyMessages : Messages
emptyMessages = Dict.empty

fromList : List (String, String) -> Messages
fromList l = Dict.fromList l

msg : String -> Messages -> String
msg key messages = Dict.get key messages |> M.withDefault key
