module CoreExtra where

import Maybe
import Array


isNothing : Maybe a -> Bool
isNothing m =
  case m of
    Nothing -> True
    _ -> False


isJust : Maybe a -> Bool
isJust m =
  not (isNothing m)


removeAt : Int -> List a -> List a
removeAt i items =
  (List.take i items) ++ (List.drop (i + 1) items)


updateAt : Int -> (a -> a) -> List a -> List a
updateAt i update items =
  let
    asArray = Array.fromList items
  in
    case Array.get i asArray of
      Just item ->
        asArray
          |> Array.set i (update item)
          |> Array.toList
      Nothing ->
        items

within : (number, number) -> number -> Bool
within (a, b) c =
  c >= a && c <= b

