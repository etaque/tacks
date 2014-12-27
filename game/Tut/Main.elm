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

port serverUpdate : Signal ServerUpdate

clock : Signal Float
clock = fps 30

input : Signal TutInput
input = sampleOn clock <| map5 TutInput
  clock
  keyboardInput
  nextStepInput
  Window.dimensions
  serverUpdate

tutState : Signal TutState
tutState = foldp mainStep defaultTutState input

port playerOutput : Signal KeyboardInput
port playerOutput = .keyboard <~ input

main : Signal Element
main = map2 render Window.dimensions tutState
