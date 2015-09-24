module Game.Render.Defs where

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)

renderDefs : Svg
renderDefs =
  defs [ ]
    [ pattern
      [ id "seaPattern"
      , x "0", y "0"
      , width "50", height "120"
      , patternUnits "userSpaceOnUse"
      ]
      [ rect [ x "0", y "0", width "50", height "30", fill "grey", opacity "0.05" ] [ ]
      , rect [ x "0", y "30", width "50", height "30", fill "grey", opacity "0.1" ] [ ]
      , rect [ x "0", y "60", width "50", height "30", fill "grey", opacity "0.05" ] [ ]
      ]
    , marker
      [ id "whiteFullArrow"
      , markerWidth "6", markerHeight "6"
      , refX "0", refY "3"
      , orient "auto"
      ]
      [ Svg.path [ d "M0,0 L0,6 L6,3 L0,0", fill "white" ] [ ] ]
    , linearGradient
      [ id "transparentToBlack"
      ]
      [ stop [ offset "0%", stopColor "black", stopOpacity "0" ] [ ]
      , stop [ offset "100%", stopColor "black", stopOpacity "1" ] [ ]
      ]
    , linearGradient
      [ id "midBlack"
      ]
      [ stop [ offset "0%", stopColor "black", stopOpacity "0.5" ] [ ]
      , stop [ offset "100%", stopColor "black", stopOpacity "1" ] [ ]
      ]
    ]



