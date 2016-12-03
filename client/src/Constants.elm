module Constants exposing (..)

import Color exposing (Color)


sidebarWidth =
    270


toolbarHeight =
    52


headerHeight =
    154


containerWidth =
    940


gutterWidth =
    30


transitionDuration =
    100


rgbColors =
    { water = ( 33, 148, 206 )
    , sand = ( 226, 219, 190 )
    , grass = ( 200, 230, 180 )
    , rock = ( 171, 196, 198 )
    }


colors =
    { water = toStringColor rgbColors.water
    , sand = toStringColor rgbColors.sand
    , grass = toStringColor rgbColors.grass
    , rock = toStringColor rgbColors.rock
    , green = "rgb(100, 180, 106)"
    }


toStringColor : ( Int, Int, Int ) -> String
toStringColor ( r, g, b ) =
    "rgb(" ++ toString r ++ ", " ++ toString g ++ "," ++ toString b ++ ")"


seaBlue : Color
seaBlue =
    Color.rgb 33 148 206


hexRadius : Float
hexRadius =
    50


admins : List String
admins =
    [ "milox" ]
