module Hexagons (axialToPoint, pointToAxial, axialLine, axialDistance, axialRange) where

{-| Suite of functions for horizontal axial grid handling, focused on horizontal grids ("pointy topped") with axial coordinate system.

See http://www.redblobgames.com/grids/axialagons for reference.

# Cubic (3D) types
@docs Cube, FloatCube, IntCube

# Plan (2D) types
@docs Axial, Point

# Conversions
@docs axialToPoint, pointToAxial

# Measuring
@docs axialDistance

# Drawing
@docs axialLine, axialRange
-}

type alias Cube number = (number, number, number)
type alias FloatCube = Cube Float
type alias IntCube = Cube Int

type alias Axial = (Int, Int)
type alias Point = (Float, Float)


{-| Given axial radius and axial coords, return pixel coords of its center
-}
axialToPoint : Float -> Axial -> Point
axialToPoint axialRadius (i, j) =
  let
    x = axialRadius * (sqrt 3) * (toFloat i + toFloat j / 2)
    y = axialRadius * 3 / 2 * toFloat j
  in
    (x, y)


{-| Given axial radius and pixel coords, returns corresponding axial coords
-}
pointToAxial : Float -> Point -> Axial
pointToAxial axialRadius (x, y) =
  let
    i = (x * (sqrt 3) / 3 - y / 3) / axialRadius
    j = y * (2 / 3) / axialRadius
  in
    axialRound (i, j)


{-| List all hexagons composing a line between two hexagons.
See http://www.redblobgames.com/grids/axialagons/#line-drawing
 -}
axialLine : Axial -> Axial -> List Axial
axialLine a b =
  List.map cubeToAxial (cubeLine (axialToCube a) (axialToCube b))


{-| List all hexagons within given distance of this one
See http://www.redblobgames.com/grids/axialagons/#range
-}
axialRange : Axial -> Int -> List Axial
axialRange center n =
  let
    mapX dx =
      let
        fromY = max -n (-dx - n)
        toY = min n (-dx + n)
        mapY dy = axialAdd center (dx, dy)
      in
        List.map mapY [ fromY .. toY ]
  in
    List.concatMap mapX [ -n .. n ]


axialRound : (Float, Float) -> Axial
axialRound =
  axialToCube >> cubeRound >> cubeToAxial


cubeRound : FloatCube -> IntCube
cubeRound (x, y, z) =
  let
    rx = round x
    ry = round y
    rz = round z

    xDiff = abs (toFloat rx - x)
    yDiff = abs (toFloat ry - y)
    zDiff = abs (toFloat rz - z)
  in
    if xDiff > yDiff && xDiff > zDiff then
      (-ry-rz, ry, rz)
    else if yDiff > zDiff then
           (rx, -rx-rz, rz)
         else (rx, ry, -rx-ry)


cubeDistance : IntCube -> IntCube -> Int
cubeDistance (ax, ay, az) (bx, by, bz) =
  (abs (ax - bx) + abs (ay - by) + abs (az - bz)) // 2


axialDistance : Axial -> Axial -> Int
axialDistance a b =
  cubeDistance (axialToCube a) (axialToCube b)


cubeLinearInterpol : IntCube -> IntCube -> Float -> Cube Float
cubeLinearInterpol a b t =
  let
    (ax, ay, az) = floatCube a
    (bx, by, bz) = floatCube b
    i = ax + (bx - ax) * t
    j = ay + (by - ay) * t
    k = az + (bz - az) * t
  in
    (i, j, k)


floatCube : IntCube -> FloatCube
floatCube (x, y, z) =
  (toFloat x, toFloat y, toFloat z)


cubeLine : IntCube -> IntCube -> List (IntCube)
cubeLine a b =
  let
    n = cubeDistance a b
    offsetMapper i = cubeRound (cubeLinearInterpol a b (1 / (toFloat n) * (toFloat i)))
  in
    List.map offsetMapper [ 0..n ]


axialAdd : Axial -> Axial -> Axial
axialAdd (x, y) (x', y') =
  (x + x', y + y')


cubeAdd : IntCube -> IntCube -> IntCube
cubeAdd (x, y, z) (i, j, k) =
  (x + i, y + j, z + k)


cubeToAxial : Cube number -> (number, number)
cubeToAxial (x, y, z) =
  (x, y)


axialToCube : (number, number) -> Cube number
axialToCube (i, j) =
  (i, j, -i-j)

