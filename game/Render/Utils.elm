module Render.Utils where

import String
import Text

helpMessage : String
helpMessage = "←/→ to turn left/right, SHIFT + ←/→ to fine tune direction, \n↑ or ENTER to lock angle to wind, SPACE to tack/jibe, S to cast a spell"

colors = { seaBlue = rgb 10 105 148,
           sand = rgb 239 210 121,
           buoy = white }

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
  |> Text.height 14
  |> Text.color white
  |> monospace
