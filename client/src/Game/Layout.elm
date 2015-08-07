module Game.Layout where

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import List exposing (..)

type alias DashboardLayout =
  { topLeft:      List Element
  , topRight:     List Element
  , topCenter:    List Element
  , bottomCenter: List Element
  }

type alias Layout =
  { dashboard: DashboardLayout
  , relStack:  List Form
  , absStack:  List Form
  }

centerElements : List Element -> List Element
centerElements elements =
  let
    maxWidth = maximum (map widthOf elements) |> Maybe.withDefault 0
  in
    map (\e -> container maxWidth (heightOf e) midTop e) elements

assembleDashboardLayout : (Int,Int) -> DashboardLayout -> List Element
assembleDashboardLayout (w,h) {topLeft,topRight,topCenter,bottomCenter} =
  [ container w h (topLeftAt (absolute 20) (absolute 20)) <| flow down topLeft
  , container w h (midTopAt (relative 0.5) (absolute 20)) <| flow down (centerElements topCenter)
  , container w h (topRightAt (absolute 20) (absolute 20)) <| flow down topRight
  ]

assembleLayout : (Int,Int) -> (Float,Float) -> Layout -> Element
assembleLayout (w,h) (cx,cy) {dashboard,relStack,absStack} =
  let
    relStackElements = collage w h (map (move (-cx,-cy)) relStack)
    absStackElements = collage w h absStack
    dashboardElements = assembleDashboardLayout (w,h) dashboard
  in
    layers (append [relStackElements, absStackElements] dashboardElements)
