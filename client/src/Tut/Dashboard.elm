module Tut.Dashboard where

import Graphics.Collage (..)
import Graphics.Element (..)
import Text (centered,leftAligned)
import List (..)

import Render.Utils (..)
import Layout (..)
import Tut.State (..)
import Messages (..)

getMainStatus : TutState -> Element
getMainStatus tutState =
  msg ("tutorial.steps." ++ (toString tutState.step) ++ ".title") tutState.messages
    |> bigText |> centered

getSubStatus : TutState -> Element
getSubStatus tutState =
  msg ("tutorial.steps." ++ (toString tutState.step) ++ ".subtitle") tutState.messages
    |> baseText |> centered

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

buildDashboard : TutState -> DashboardLayout
buildDashboard tutState =
  { topLeft = topLeftElements tutState
  , topRight = topRightElements tutState
  , topCenter = topCenterElements tutState
  , bottomCenter = bottomCenterElements tutState
  }
