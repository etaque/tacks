module Geo where

import Core

type Point = (Float, Float)
type Segment = (Point, Point)

floatify (x,y) = (toFloat x, toFloat y)

sub : Point -> Point -> Point
sub (x,y) (x',y') = (x' - x, y' - y)

neg : Point -> Point
neg (x,y) = (-x,-y)

distance : Point -> Point -> Float
distance (x,y) (x',y') =
  sqrt <| (x - x')^2 + (y - y')^2

inBox : Point -> (Point,Point) -> Bool
inBox (x, y) ((xMax, yMax), (xMin, yMin)) =
  x > xMin && x < xMax && y > yMin && y < yMax

movePoint : Point -> Time -> Float -> Int -> Point
movePoint (x,y) delta velocity direction = 
  let angle = Core.toRadians direction
      x' = x + delta * velocity * cos angle
      y' = y + delta * velocity * sin angle
  in (x',y')