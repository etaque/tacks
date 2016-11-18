module Game.Render.SvgUtils exposing (..)

import Model.Shared exposing (..)
import Game.Geo as Geo exposing (rotateDeg)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import String


translate : number -> number -> String
translate x y =
    "translate(" ++ (toString x) ++ ", " ++ (toString y) ++ ")"


translatePoint : Point -> String
translatePoint ( x, y ) =
    translate x y


rotate_ : number -> number -> number -> String
rotate_ a cx cy =
    "rotate(" ++ toString a ++ ", " ++ toString cx ++ ", " ++ toString cy ++ ")"


segment : List (Attribute msg) -> ( Point, Point ) -> Svg msg
segment attrs ( p1, p2 ) =
    line (attrs ++ (lineCoords p1 p2)) []


polygonPoints : List Point -> Attribute msg
polygonPoints pointsList =
    List.map (\( x, y ) -> toString x ++ "," ++ toString y) pointsList
        |> String.join " "
        |> points


pathPoints : List Point -> Attribute msg
pathPoints pointsList =
    let
        coords =
            List.map (\( x, y ) -> toString x ++ "," ++ toString y) pointsList
                |> String.join " "
    in
        d ("M " ++ coords)


lineCoords : Point -> Point -> List (Attribute msg)
lineCoords p1 p2 =
    let
        x =
            Tuple.first >> toString

        y =
            Tuple.second >> toString
    in
        [ x1 (x p1)
        , y1 (y p1)
        , x2 (x p2)
        , y2 (y p2)
        ]


type alias ArcDef =
    { center : Point
    , radius : Float
    , fromAngle : Float
    , toAngle : Float
    }


arc : List (Attribute msg) -> ArcDef -> Svg msg
arc attrs { center, radius, fromAngle, toAngle } =
    let
        ( x1, y1 ) =
            Geo.sub (rotateDeg fromAngle radius) center

        ( x2, y2 ) =
            Geo.sub (rotateDeg toAngle radius) center

        moveCmd =
            buildCmd "M" [ x1, y1 ]

        arcCmd =
            buildCmd "A" [ radius, radius, 0, 0, 0, x2, y2 ]

        cmd =
            moveCmd ++ arcCmd
    in
        Svg.path
            ((d cmd) :: attrs)
            []


buildCmd : String -> List number -> String
buildCmd cmd numbers =
    cmd
        :: (List.map toString numbers)
        |> String.join " "


empty : Svg msg
empty =
    g [] []
