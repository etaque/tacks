module Geo where

type Point = (Float, Float)

sub : Point -> Point -> Point
sub (x,y) (x',y') = (x' - x, y' - y)

neg : Point -> Point
neg (x,y) = (-x,-y)

distance : Point -> Point -> Float
distance (x,y) (x',y') =
  sqrt <| (x - x')^2 + (y - y')^2
