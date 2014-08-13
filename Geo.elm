module Geo where

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
  