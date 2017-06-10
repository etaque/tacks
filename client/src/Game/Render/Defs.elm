module Game.Render.Defs exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)


renderDefs : Svg msg
renderDefs =
    defs []
        [ marker
            [ id "whiteFullArrow"
            , markerWidth "6"
            , markerHeight "6"
            , refX "0"
            , refY "3"
            , orient "auto"
            ]
            [ Svg.path [ d "M0,0 L0,6 L6,3 L0,0", fill "white" ] [] ]
        , linearGradient
            [ id "transparentToBlack"
            ]
            [ stop [ offset "0%", stopColor "black", stopOpacity "0" ] []
            , stop [ offset "100%", stopColor "black", stopOpacity "1" ] []
            ]
        ]
