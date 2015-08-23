module CoreExtra where

import Maybe as M


isNothing : Maybe a -> Bool
isNothing m =
  case m of
    Nothing -> True
    _ -> False

isJust : Maybe a -> Bool
isJust m =
  not (isNothing m)
