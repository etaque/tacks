module Geo where

type Point = (Float, Float)

sub : Point -> Point -> Point
sub (x,y) (x',y') = (x' - x, y' - y)
