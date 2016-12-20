module Game.Utils exposing (..)

import Time exposing (Time)
import Model.Shared exposing (Point, Segment)


toRadians : Float -> Float
toRadians deg =
    radians ((90 - deg) * pi / 180)


toDegrees : Float -> Float
toDegrees rad =
    -rad * 180 / pi + 90


sign : number -> Int
sign n =
    if n == 0 then
        n
    else if n < 0 then
        -1
    else
        1


within : ( comparable, comparable ) -> comparable -> Bool
within ( a, b ) c =
    c >= a && c <= b


floatRange : Int -> Int -> List Float
floatRange from to =
    List.map toFloat (List.range from to)


floatify : ( Int, Int ) -> ( Float, Float )
floatify ( x, y ) =
    ( toFloat x, toFloat y )


add : Point -> Point -> Point
add ( x, y ) ( x_, y_ ) =
    ( x_ + x, y_ + y )


sub : Point -> Point -> Point
sub ( x, y ) ( x_, y_ ) =
    ( x_ - x, y_ - y )


neg : Point -> Point
neg ( x, y ) =
    ( -x, -y )


scale : Float -> Point -> Point
scale s ( x, y ) =
    ( x * s, y * s )


distance : Point -> Point -> Float
distance ( x, y ) ( x_, y_ ) =
    sqrt <| (x - x_) ^ 2 + (y - y_) ^ 2


inBox : Point -> ( Point, Point ) -> Bool
inBox ( x, y ) ( ( xMax, yMax ), ( xMin, yMin ) ) =
    x > xMin && x < xMax && y > yMin && y < yMax


toBox : Point -> Float -> Float -> ( Point, Point )
toBox ( x, y ) w h =
    ( ( x + w / 2, y + h / 2 ), ( x - w / 2, y - h / 2 ) )


movePoint : Point -> Time -> Float -> Float -> Point
movePoint ( x, y ) delta velocity direction =
    let
        angle =
            toRadians direction

        x_ =
            x + delta * 0.001 * velocity * cos angle

        y_ =
            y + delta * 0.001 * velocity * sin angle
    in
        ( x_, y_ )


rotateDeg : Float -> Float -> Point
rotateDeg deg radius =
    let
        a =
            toRadians deg
    in
        ( radius * cos a, radius * sin a )


ensure360 : Float -> Float
ensure360 val =
    let
        rounded =
            round val

        excess =
            val - (toFloat rounded)
    in
        ((rounded + 360) % 360 |> toFloat) + excess


angleDelta : Float -> Float -> Float
angleDelta a1 a2 =
    let
        delta =
            a1 - a2
    in
        if delta > 180 then
            delta - 360
        else if delta <= -180 then
            delta + 360
        else
            delta


angleBetween : Point -> Point -> Float
angleBetween ( x1, y1 ) ( x2, y2 ) =
    let
        xDelta =
            x2 - x1

        yDelta =
            y2 - y1

        rad =
            atan2 yDelta xDelta
    in
        ensure360 (toDegrees rad)


{-| is angle included in sector?
-}
inSector : Float -> Float -> Float -> Bool
inSector b1 b2 angle =
    let
        a1 =
            -(angleDelta b1 angle)

        a2 =
            -(angleDelta angle b2)
    in
        a1 >= 0 && a2 >= 0
