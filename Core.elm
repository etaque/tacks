module Core where

ensure360 : Int -> Int
ensure360 val = (val + 360) `mod` 360

toRadians : Int -> Float
toRadians deg = radians (toFloat(90 - deg) * pi / 180)

mpsToKnts : Float -> Float
mpsToKnts mps = mps * 3600 / 1.852 / 1000 

angleToWind : Int -> Int -> Int
angleToWind boatDirection windOrigin =
  let delta = boatDirection - windOrigin
  in 
    if | delta > 180   -> delta - 360
       | delta <= -180 -> delta + 360
       | otherwise     -> delta


polarVelocity : Int -> Float
polarVelocity delta =
  let x = toFloat(delta)
      v = 1.084556812 * (10^ -6) * (x^3) - 1.058704484 * (10^ -3) * (x^2) +
        0.195782694 * x - 7.136475544 * (10^ -1)
  in if v < 0 then v else v

-- deals with inertia
boatVelocity : Int -> Float -> Float
boatVelocity windAngle previousVelocity =
  let v = polarVelocity(abs windAngle) * 5
      delta = v - previousVelocity
  in previousVelocity + delta * 0.02

mapMaybe : (a -> b) -> Maybe a -> Maybe b
mapMaybe f maybe =
    case maybe of
      Just v  -> Just (f v)
      Nothing -> Nothing
