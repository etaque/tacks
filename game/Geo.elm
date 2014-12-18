module Geo where

import Core

import Time (..)

type alias Point = (Float, Float)
type alias Segment = (Point, Point)

floatify (x,y) = (toFloat x, toFloat y)

add : Point -> Point -> Point
add (x,y) (x',y') = (x' + x, y' + y)

sub : Point -> Point -> Point
sub (x,y) (x',y') = (x' - x, y' - y)

neg : Point -> Point
neg (x,y) = (-x,-y)

scale : Float -> Point -> Point
scale s (x,y) = (x*s, y*s)

distance : Point -> Point -> Float
distance (x,y) (x',y') =
  sqrt <| (x - x')^2 + (y - y')^2

inBox : Point -> (Point,Point) -> Bool
inBox (x, y) ((xMax, yMax), (xMin, yMin)) =
  x > xMin && x < xMax && y > yMin && y < yMax

toBox : Point -> Float -> Float -> (Point,Point)
toBox (x,y) w h =
  ((x + w/2, y + h/2), (x - w/2, y - h/2))

movePoint : Point -> Time -> Float -> Float -> Point
movePoint (x,y) delta velocity direction =
  let angle = Core.toRadians direction
      x' = x + delta * 0.001 * velocity * cos angle
      y' = y + delta * 0.001 * velocity * sin angle
  in (x',y')
