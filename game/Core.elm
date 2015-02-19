module Core where

import Maybe as M
import Time (..)
import List (..)



toRadians : Float -> Float
toRadians deg = radians ((90 - deg) * pi / 180)

toDegrees : Float -> Float
toDegrees rad = degrees (-rad) + 90

mpsToKnts : Float -> Float
mpsToKnts mps = mps * 3600 / 1.852 / 1000

floatMod : Float -> Int -> Float
floatMod val div =
  (floor val) % div |> toFloat

--

--getVmgValue : Float -> Float  -> Float
--getVmgValue windAngle boatSpeed =
--  let windAngleRad = toRadians windAngle
--  in  (sin windAngleRad) * boatSpeed |> abs



getCountdown : Maybe Time -> Float
getCountdown maybeCountdown = M.withDefault 0 maybeCountdown


-- List

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

exists : (a -> Bool) -> List a -> Bool
exists f list =
  isJust (find f list)

headMaybe : List a -> Maybe a
headMaybe list =
  if isEmpty list then Nothing else Just (head list)

floatRange : Int -> Int -> List Float
floatRange from to =
  map toFloat [ from .. to ]

-- Maybe

isNothing : Maybe a -> Bool
isNothing m =
  case m of
    Nothing -> True
    _ -> False

isJust : Maybe a -> Bool
isJust m =
  not (isNothing m)
