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

ensure360 : Float -> Float
ensure360 val =
  let rounded = round val
      excess = val - (toFloat rounded)
  in  ((rounded + 360) % 360 |> toFloat) + excess

angleDelta : Float -> Float -> Float
angleDelta a1 a2 =
  let
    delta = a1 - a2
  in
    if | delta > 180   -> delta - 360
       | delta <= -180 -> delta + 360
       | otherwise     -> delta

angleBetween : Point -> Point -> Float
angleBetween (x1, y1) (x2, y2) =
  let
    xDelta = x2 - x1
    yDelta = y2 - y1
    rad = atan2 yDelta xDelta
  in
    ensure360 (Core.toDegrees rad)

{-| is angle included in sector?
-}
inSector : Float -> Float -> Float -> Bool
inSector b1 b2 angle =
  let
    a1 = -(angleDelta b1 angle)
    a2 = -(angleDelta angle b2)
  in
    a1 >= 0 && a2 >= 0