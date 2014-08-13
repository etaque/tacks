module Core where

ensure360 : Int -> Int
ensure360 val = (val + 360) `mod` 360

toRadians : Int -> Float
toRadians deg = radians (toFloat(90 - deg) * pi / 180)

angleToWind : Int -> Int -> Int
angleToWind boatDirection windOrigin =
  let delta = boatDirection - windOrigin
  in 
    if | delta > 180   -> delta - 360
       | delta <= -180 -> delta + 360
       | otherwise     -> delta