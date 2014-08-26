module Render.All where

import Core (..)
import Geo (..)
import Game (..)
import String
import Text

import Render.Relative (..)
import Render.Absolute (..)

renderAll : (Int,Int) -> GameState -> Element
renderAll (w,h) gameState =
  let dims = floatify (w,h)
      (w',h') = dims
      relativeToCenter = renderRelative gameState
      absolute = renderAbsolute gameState dims      
      bg = rect w' h' |> filled colors.sand
  in  layers [collage w h [bg, group [relativeToCenter, absolute]]]
