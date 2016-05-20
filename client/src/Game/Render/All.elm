module Game.Render.All exposing (..)

import Game.Models exposing (..)
import Game.Render.SvgUtils exposing (..)
import Game.Render.Defs exposing (..)
import Game.Render.Course exposing (..)
import Game.Render.Players exposing (..)
import Game.Render.Dashboard exposing (..)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


render : ( Int, Int ) -> GameState -> Html msg
render ( w, h ) ({ playerState, course, wind } as gameState) =
  let
    cx =
      (toFloat w) / 2 - (fst gameState.center)

    cy =
      (toFloat h) / 2 - (toFloat h) - (snd gameState.center)
  in
    svg
      [ width (toString w)
      , height (toString h)
      , version "1.1"
      ]
      [ renderDefs
      , g
          [ transform ("scale(1,-1)" ++ (translate cx cy)) ]
          [ renderCourse gameState
          , renderPlayers gameState
          ]
      , renderDashboard ( w, h ) gameState
      ]
