module Messages where

import Dict
import Maybe as M
import Json.Decode as Json
import Result

type alias Messages = Dict.Dict String String

type alias Translator = String -> String

emptyMessages : Messages
emptyMessages = Dict.empty

fromList : List (String, String) -> Messages
fromList l = Dict.fromList l

fromJson : Json.Value -> Messages
fromJson value =
  Json.decodeValue (Json.dict Json.string) value
    |> Result.toMaybe
    |> M.withDefault emptyMessages

msg : String -> Messages -> String
msg key messages = Dict.get key messages |> M.withDefault key

translator : Messages -> String -> String
translator messages key = Dict.get key messages |> M.withDefault key
