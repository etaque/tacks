module Core where

ensure360 : Float -> Float
ensure360 val = ((round val) + 360) `mod` 360 |> toFloat

toRadians : Float -> Float
toRadians deg = radians ((90 - deg) * pi / 180)

mpsToKnts : Float -> Float
mpsToKnts mps = mps * 3600 / 1.852 / 1000 

angleToWind : Float -> Float -> Float
angleToWind playerDirection windOrigin =
  let delta = playerDirection - windOrigin
  in 
    if | delta > 180   -> delta - 360
       | delta <= -180 -> delta + 360
       | otherwise     -> delta

--angleDelta : Float -> Float -> Float
--angleDelta a1 a2 =
--  let delta = a1 - a2
--  in 
--    if | delta > 360   -> delta - 180
--       | delta <= 0    -> delta + 180
--       | otherwise     -> delta


-- polynomial regression of AC72 polar
-- see http://noticeboard.americascup.com/wp-content/uploads/actv/LV13/AC72polar.130714.txt
-- and http://www.xuru.org/rt/MPR.asp
polarVelocity : Float -> Float
polarVelocity angle =
  let x1 = 15
      x2 = angle
      v = -8.629353458 * 10^ -4 * x1^3 
          - 1.150751365 * 10^ -6 * x1^2 * x2 
          - 1.545154964 * 10^ -4 * x1 * x2^2 
          - 1.576508561 * 10^ -5 * x2^3 
          + 1.013664743 * 10^ -2 * x2 
          + 3.818064169 * 10^ -2 * x1 * x2 
          + 3.661699453 * 10^ -3 * x2^2 
          - 6.076025593 * 10^ -1 * x1 
          - 2.385773381 * 10^ -1 * x2 
          + 14.77328598
  in v * 2 -- articifial speed factor

vmgValue : Float  -> Float
vmgValue a = abs ((cos (toRadians a)) * (polarVelocity a))

upwindVmg : Float
upwindVmg =
  map (\a -> (a, vmgValue a)) [30..60] |> sortBy snd |> last |> fst

downwindVmg : Float
downwindVmg =
  map (\a -> (a, vmgValue a)) [130..180] |> sortBy snd |> last |> fst

-- deals with inertia
playerVelocity : Float -> Float -> Float
playerVelocity windAngle previousVelocity =
  let v = polarVelocity(abs windAngle)
      delta = v - previousVelocity
  in previousVelocity + delta * 0.02


mapMaybe : (a -> b) -> Maybe a -> Maybe b
mapMaybe f maybe =
    case maybe of
      Just v  -> Just (f v)
      Nothing -> Nothing

compact : [Maybe a] -> [a]
compact maybes =
  let folder : Maybe b -> [b] -> [b]
      folder m list = case m of
                        Just j  -> j :: list
                        Nothing -> list
  in foldl folder [] maybes

average : [Float] -> Float
average items = (sum items) / (toFloat (length items))

indexedMap : (Int -> a -> b) -> [a] -> [b]
indexedMap f xs =
    zipWith f [ 0 .. length xs - 1 ] xs