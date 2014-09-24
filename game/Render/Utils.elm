module Render.Utils where

import String
import Text

helpMessage = "←/→ to turn left/right, SHIFT + ←/→ to fine tune direction, \n" ++
  "ENTER to lock angle to wind, SPACE to tack/jibe, S to cast a spell"

startCountdownMessage = "press C to start countdown (60s)"

colors =
  { seaBlue = rgb 10 105 148
  , sand = rgb 239 210 121
  , gateMark = orange
  , gateLine = orange
  }

fullScreenMessage : String -> Form
fullScreenMessage msg = msg
  |> String.toUpper
  |> toText
  |> Text.height 60
  |> Text.color white
  |> centered
  |> toForm
  |> alpha 0.3

baseText : String -> Text
baseText s = s
  |> toText
  |> Text.height 15
  |> typeface ["Inconsolata", "monospace"]

triangle : Float -> Bool -> Path
triangle s isUpward =
  if isUpward then
    polygon [(0,0),(-s,-s),(s,-s)]
  else
    polygon [(0,0),(-s,s),(s,s)]

