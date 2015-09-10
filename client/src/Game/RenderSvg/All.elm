module Game.RenderSvg.All where

import Game.Models exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)

import Game.RenderSvg.Course exposing (..)
import Game.RenderSvg.Players exposing (..)
import Game.RenderSvg.Dashboard exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)



render : (Int, Int) -> GameState -> Html
render (w, h) ({playerState,course,now,wind} as gameState) =
  let
    cx = (toFloat w) / 2 - (fst gameState.center)
    cy = (toFloat h) / 2 - (toFloat h) - (snd gameState.center)
  in
    svg
      [ width (toString w)
      , height (toString h)
      , version "1.1"
      ]
      [ defs [ ]
        [ pattern [ id "seaPattern", x "0", y "0", width "50", height "120", patternUnits "userSpaceOnUse" ]
          [ rect [ x "0", y "0", width "50", height "30", fill "grey", opacity "0.05" ] [ ]
          , rect [ x "0", y "30", width "50", height "30", fill "grey", opacity "0.1" ] [ ]
          , rect [ x "0", y "60", width "50", height "30", fill "grey", opacity "0.05" ] [ ]
          ]
        , marker [ id "whiteFullArrow", markerWidth "6", markerHeight "6", refX "0", refY "3", orient "auto" ]
          [ Svg.path [ d "M0,0 L0,6 L6,3 L0,0", fill "white" ] [ ] ]
        ]

      -- , Svg.filter [ id "noise" ]
      --   [ feTurbulence
      --     [ type' "fractalNoise"
      --     , baseFrequency "0.7"
      --     , numOctaves "10"
      --     , stitchTiles "stitch"
      --     ]
      --     [ ]
      --   ]
      , g
        [ transform ("scale(1,-1)" ++ (translate cx cy)) ]
        [ renderCourse gameState
        , renderPlayers gameState
        ]
      , renderDashboard (w,h) gameState
      ]










