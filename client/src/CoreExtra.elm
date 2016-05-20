module CoreExtra exposing (..)

import Maybe
import Array
import Task exposing (Task)
import Time exposing (Time)
import Process


find : (a -> Bool) -> List a -> Maybe a
find f items =
  List.filter f items |> List.head


isNothing : Maybe a -> Bool
isNothing m =
  case m of
    Nothing ->
      True

    _ ->
      False


isJust : Maybe a -> Bool
isJust m =
  not (isNothing m)


maybeToList : Maybe a -> List a
maybeToList ma =
  case ma of
    Just a ->
      [ a ]

    _ ->
      []


removeAt : Int -> List a -> List a
removeAt i items =
  (List.take i items) ++ (List.drop (i + 1) items)


getAt : Int -> List a -> Maybe a
getAt i items =
  List.drop i items
    |> List.head


setAt : Int -> a -> List a -> List a
setAt i item items =
  updateAt i (\_ -> item) items


updateAt : Int -> (a -> a) -> List a -> List a
updateAt i update items =
  let
    asArray =
      Array.fromList items
  in
    case Array.get i asArray of
      Just item ->
        asArray
          |> Array.set i (update item)
          |> Array.toList

      Nothing ->
        items


within : ( comparable, comparable ) -> comparable -> Bool
within ( a, b ) c =
  c >= a && c <= b


performSucceed : (a -> msg) -> Task Never a -> Cmd msg
performSucceed =
  Task.perform never


toCmd : msg -> Cmd msg
toCmd msg =
  performSucceed identity (Task.succeed msg)


never : Never -> a
never n =
  never n


delay : Time -> Task x a -> Task x a
delay t task =
  Process.sleep t `Task.andThen` (\_ -> task)
