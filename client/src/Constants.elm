module Constants exposing (..)

import Color exposing (Color)


sidebarWidth =
    270


appbarHeight =
    52


headerHeight =
    154


containerWidth =
    940


gutterWidth =
    30


transitionDuration =
    100


colors =
    { water =
        "rgb(33, 148, 206)"
        -- "rgb(147, 202, 223)"
    , sand = "rgb(226, 219, 190)"
    , grass = "rgb(200, 230, 180)"
    , rock = "rgb(171, 196, 198)"
    , green = "rgb(100, 180, 106)"
    }


seaBlue : Color
seaBlue =
    Color.rgb 33 148 206


hexRadius : Float
hexRadius =
    50


admins : List String
admins =
    [ "milox" ]
