module Tut.Main where

import Window
import Signal (..)
import Time (..)
import Graphics.Element (Element)

import Inputs (..)
import Tut.Inputs (..)
import Tut.State (..)
import Tut.Steps (..)
import Tut.Render (render)

clock : Signal Float
clock = fps 30

--time : Signal Float
--time = foldp (+) 0 clock

input : Signal TutInput
input = sampleOn clock <| map4 TutInput
  clock
  keyboardInput
  nextStepInput
  Window.dimensions

tutState : Signal TutState
tutState = foldp mainStep defaultTutState input

main : Signal Element
main = map2 render Window.dimensions tutState
