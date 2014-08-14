module GameSkeleton where

import Window

import Inputs (..)
import Game (..)
import Steps (..)
import Render (..)


{-- That's all folks! ---------------------------------------------------------

The following code puts it all together and shows it on screen.

------------------------------------------------------------------------------}

clock = timestamp (inSeconds <~ fps 30)
input = sampleOn clock (lift3 Input clock keyboardInput mouseInput)

gameState = foldp stepGame defaultGame input

main = lift2 render Window.dimensions gameState
