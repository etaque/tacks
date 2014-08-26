module Render.All where

import Core (..)
import Geo (..)
import Game (..)
import String
import Text

import Render.Relative (..)
import Render.Absolute (..)

renderRaceForBoat : (Int,Int) -> GameState -> Boat -> [Opponent] -> Element
renderRaceForBoat (w,h) gameState boat opponents =
  let dims = floatify (w,h)
      (w',h') = dims
      relativeToCenter = renderRelative gameState boat opponents
      absolute = renderAbsolute gameState boat opponents dims      
      bg = rect w' h' |> filled colors.sand
  in 
      layers [collage w h [bg, group [relativeToCenter, absolute]]]

render : (Int,Int) -> GameState -> Element
render (w,h) gameState =
  case gameState.otherBoat of
    Just otherBoat -> let w' = (div w 2) - 2
                          r1 = renderRaceForBoat (w',h) gameState gameState.boat (map boatToOpponent [otherBoat])
                          r2 = renderRaceForBoat (w',h) gameState otherBoat (map boatToOpponent [gameState.boat])
                      in flow left [r1, spacer 4 1, r2]
    Nothing        -> renderRaceForBoat (w,h) gameState gameState.boat gameState.opponents
