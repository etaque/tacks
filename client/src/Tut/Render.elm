module Tut.Render where

import Graphics.Collage (..)
import Graphics.Element (..)
import Color (white,black)
import List (..)

import Game.Render.Utils (..)
import Game.Render.Players (..)
import Game.Render.Course (..)
import Game.Render.Gates (..)

import Game (..)
import Game.Layout (assembleLayout)
import Tut.State (..)
import Tut.Dashboard (buildDashboard)


renderTutPlayer : Bool -> Bool -> Bool -> PlayerState -> Form
renderTutPlayer showLines showAngles showVmg player =
  let
    hull = rotateHull player.heading baseHull
    angles = if showAngles
      then renderPlayerAngles player
      else emptyForm
    vmgSign = if showVmg
      then renderVmgSign player
      else emptyForm
    eqLine = if showLines
      then renderEqualityLine player.position player.windOrigin
      else emptyForm
    movingPart = group [angles, vmgSign, eqLine, hull] |> move player.position
    wake = renderWake player.trail
  in
    group [wake, movingPart]


windArrowPath : Path
windArrowPath =
  path
    [ (0,0)
    , (10,10)
    , (5,10)
    , (5,25)
    , (-5,25)
    , (-5,10)
    , (-10,10)
    ]


renderWindHelpers : Float -> Course -> Form
renderWindHelpers stepTime course =
  let
    i = (round stepTime) % 2000 |> toFloat
    a = i / 2000 * 0.2
    w = areaWidth course.area
--     t =
    y = course.upwind.y - 80 - (i / 50)
    windArrow = windArrowPath
      |> filled white
      |> scale 2
    arrowForms = map (\x -> move (x,y) windArrow) [-w / 3, 0, w / 3]
  in
    group arrowForms |> alpha a


renderAbsStack : (Int,Int) -> TutState -> List Form
renderAbsStack dims {course,step,stepTime} =
  case step of
    --CourseStep ->
    --  [ renderWindHelpers dims stepTime course ]
    _ ->
      [ ]


renderRelStack : TutState -> List Form
renderRelStack ({course,step,stepTime,playerState} as tutState) =
  case step of
    InitialStep ->
      [ ]
    CourseStep ->
      [ renderBounds course.area
      , renderIslands course
      , renderGate course.downwind markRadius stepTime False Downwind
      , renderGate course.upwind markRadius stepTime False Upwind
      , renderWindHelpers stepTime course
      , renderTutPlayer False False False playerState
      ]
    TheoryStep ->
      [ ]
    GateStep ->
      [ renderBounds course.area
      , renderIslands course
      , renderStartLine course.downwind markRadius True stepTime
      , renderGate course.upwind markRadius stepTime True Upwind
      ]
    LapStep ->
      [ renderBounds course.area
      , renderIslands course
      , renderDownwind (Just playerState) course stepTime True
      , renderUpwind (Just playerState) course stepTime
      , renderTutPlayer False True True playerState
      ]
    _ ->
      [ ]

courseCenter : (Int,Int) -> TutState -> (Float,Float)
courseCenter (w,h) {step,playerState} =
  --(toFloat w / 4, 0)
  playerState.position
  --(0,0)
  --case step of
  --  InitialStep ->
  --    (0,0)
  --  CourseStep ->
  --    (0,0)
  --  TurningStep ->
  --    (0,0)
  --  TheoryStep ->
  --    (0,0)
  --  _ ->
  --    playerState.position

render : (Int,Int) -> TutState -> Element
render (w,h) tutState =
  let
    layout =
      { dashboard = buildDashboard tutState
      , relStack  = renderRelStack tutState
      , absStack  = renderAbsStack (w,h) tutState
      }
  in
    assembleLayout (w,h) (courseCenter (w,h) tutState) layout
