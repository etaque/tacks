module Core where

ensure360 : Float -> Float
ensure360 val = ((round val) + 360) `mod` 360 |> toFloat

toRadians : Float -> Float
toRadians deg = radians ((90 - deg) * pi / 180)

mpsToKnts : Float -> Float
mpsToKnts mps = mps * 3600 / 1.852 / 1000 

angleToWind : Float -> Float -> Float
angleToWind boatDirection windOrigin =
  let delta = boatDirection - windOrigin
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


polarVelocity : Float -> Float
polarVelocity delta =
  let x = delta
      v = 1.084556812 * (10^ -6) * (x^3) - 1.058704484 * (10^ -3) * (x^2) +
        0.195782694 * x - 7.136475544 * (10^ -1)
  in if v < 0 then v else v

-- deals with inertia
boatVelocity : Float -> Float -> Float
boatVelocity windAngle previousVelocity =
  let v = polarVelocity(abs windAngle) * 5
      delta = v - previousVelocity
  in previousVelocity + delta * 0.02

mapMaybe : (a -> b) -> Maybe a -> Maybe b
mapMaybe f maybe =
    case maybe of
      Just v  -> Just (f v)
      Nothing -> Nothing

average : [Float] -> Float
average items = (sum items) / (toFloat (length items))