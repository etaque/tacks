module Core where

import Maybe as M
import Time (..)
import List (..)

ensure360 : Float -> Float
ensure360 val =
  let rounded = round val
      excess = val - (toFloat rounded)
  in  ((rounded + 360) % 360 |> toFloat) + excess

toRadians : Float -> Float
toRadians deg = radians ((90 - deg) * pi / 180)

mpsToKnts : Float -> Float
mpsToKnts mps = mps * 3600 / 1.852 / 1000

floatMod : Float -> Int -> Float
floatMod val div =
  (floor val) % div |> toFloat

getVmgValue : Float -> Float  -> Float
getVmgValue windAngle boatSpeed =
  let windAngleRad = toRadians windAngle
  in  (sin windAngleRad) * boatSpeed |> abs


isStarted : Maybe Time -> Bool
isStarted maybeCountdown = M.map (\n -> n <= 0) maybeCountdown |> M.withDefault False

getCountdown : Maybe Time -> Float
getCountdown maybeCountdown = M.withDefault 0 maybeCountdown

compact : List (Maybe a) -> List a
compact maybes =
  let folder : Maybe b -> List b -> List b
      folder m list = case m of
                        Just j  -> j :: list
                        Nothing -> list
  in foldl folder [] maybes

average : List Float -> Float
average items = (sum items) / (toFloat (length items))

find : (a -> Bool) -> List a -> Maybe a
find f list =
  let
    filtered = filter f list
  in
    if isEmpty filtered then Nothing else Just (head filtered)

isNothing : Maybe a -> Bool
isNothing m =
  case m of
    Nothing -> True
    _ -> False

isJust : Maybe a -> Bool
isJust m =
  not (isNothing m)
