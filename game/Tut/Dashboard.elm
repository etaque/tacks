module Tut.Dashboard where

import Graphics.Collage (..)
import Graphics.Element (..)
import Text (centered,leftAligned)
import List (..)

import Render.Utils (..)

--import Game (..)
import Tut.State (..)

getMainStatus : TutState -> Element
getMainStatus tutState =
  bigText "Hello there!" |> centered


getSubStatus : TutState -> Element
getSubStatus tutState =
  baseText "This is your boat. Wind is coming from the top of the screen.\nYou can turn with LEFT/RIGHT keyboard arrows." |> centered

topLeftElements : TutState -> List Element
topLeftElements tutState = []

midTopElement : TutState -> Element
midTopElement tutState =
  let
    mainStatus = getMainStatus tutState
    subStatus = getSubStatus tutState
    maxWidth = maximum [widthOf mainStatus, widthOf subStatus]
    mainStatusCentered = container maxWidth (heightOf mainStatus) midTop mainStatus
    subStatusCentered = container maxWidth (heightOf subStatus) midTop subStatus
  in
    mainStatusCentered `above` subStatusCentered

topRightElements : TutState -> List Element
topRightElements tutState = []
  --[ getWindWheel wind
  --, s
  --, M.map getVmgBar playerState |> M.withDefault empty
  --]

midBottomElements : TutState -> List Element
midBottomElements tutState =
  [ baseText "when ready, press ESC for next step" |> leftAligned ]

renderDashboard : TutState -> (Int,Int) -> Element
renderDashboard ({playerState,step} as tutState) (w,h) =
  layers
    [ container w h (topLeftAt (Absolute 20) (Absolute 20)) <| flow down (topLeftElements tutState)
    , container w h (midTopAt (Relative 0.5) (Absolute 20)) <| midTopElement tutState
    , container w h (topRightAt (Absolute 20) (Absolute 20)) <| flow down (topRightElements tutState)
    , container w h (midBottomAt (Relative 0.5) (Absolute 20)) <| flow up (midBottomElements tutState)
    ]
