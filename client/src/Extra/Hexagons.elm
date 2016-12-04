module Extra.Hexagons exposing (..)

import Hexagons exposing (Axial)


makeRect : Float -> Int -> Int -> List Axial
makeRect hexRadius w h =
    makeRectRec hexRadius w h 0 []


makeRectRec : Float -> Int -> Int -> Int -> List Axial -> List Axial
makeRectRec hexRadius w h j grid =
    if getPixelY hexRadius (j - 1) > toFloat h then
        grid
    else
        makeRectRec hexRadius w h (j + 1) (grid ++ (makeRow hexRadius j w))


makeRow : Float -> Int -> Int -> List Axial
makeRow hexRadius j w =
    let
        y =
            getPixelY hexRadius j

        ( from, _ ) =
            Hexagons.pointToAxial hexRadius ( 0, y )

        ( to, _ ) =
            Hexagons.pointToAxial hexRadius ( toFloat w, y )
    in
        List.map (\i -> ( i, j )) (List.range from to)


getPixelY : Float -> Int -> Float
getPixelY hexRadius j =
    Hexagons.axialToPoint hexRadius ( 0, j )
        |> Tuple.second
