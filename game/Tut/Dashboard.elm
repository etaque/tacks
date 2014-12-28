module Tut.Dashboard where

import Graphics.Collage (..)
import Graphics.Element (..)
import Text (centered,leftAligned)
import List (..)

import Render.Utils (..)
import Layout (..)
import Tut.State (..)

getMainStatus : TutState -> Element
getMainStatus tutState =
  bigText "Hello there!" |> centered

getSubStatus : TutState -> Element
getSubStatus tutState =
  baseText "This is your boat. Wind is coming from the top of the screen.\nYou can turn with LEFT/RIGHT keyboard arrows." |> centered

topLeftElements : TutState -> List Element
topLeftElements tutState = []

topCenterElements : TutState -> List Element
topCenterElements tutState =
  [getMainStatus tutState, getSubStatus tutState]

topRightElements : TutState -> List Element
topRightElements tutState = []

bottomCenterElements : TutState -> List Element
bottomCenterElements tutState =
  [ baseText "when ready, press ESC for next step" |> leftAligned ]

buildDashboard : TutState -> (Int,Int) -> DashboardLayout
buildDashboard ({playerState,step} as tutState) (w,h) =
  { topLeft = topLeftElements tutState
  , topRight = topRightElements tutState
  , topCenter = topCenterElements tutState
  , bottomCenter = bottomCenterElements tutState
  }
