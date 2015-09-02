module Game.RenderSvg.Players where

import Game.Core exposing (..)
import Game.Geo as Geo
import Game.Models exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)

import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)

import List exposing (..)

renderPlayers : GameState -> Svg
renderPlayers ({playerState,opponents,ghosts,course,center} as gameState) =
  g [ ]
    [ renderOpponents course opponents
    -- , renderGhosts ghosts
    , renderPlayer playerState
    ]

renderOpponents : Course -> List Opponent -> Svg
renderOpponents course opponents =
  g [ ] (map renderOpponent opponents)


renderOpponent : Opponent -> Svg
renderOpponent {state,player} =
  let
    hull = g [ transform (translatePoint state.position), opacity "0.5" ] [ renderPlayerHull state.heading ]
    shadow = renderWindShadow state
    name = text'
      [ textAnchor "middle"
      , transform <| (translatePoint (Geo.add state.position (0,-25))) ++ "scale(1,-1)"
      , opacity "0.3"
      ]
      [ text (Maybe.withDefault "Anonymous" player.handle) ]
  in
    g [ ] [ shadow, hull, name ]

renderPlayer : PlayerState -> Svg
renderPlayer state =
  let
    playerHull = renderPlayerHull state.heading
    windShadow = renderWindShadow (asOpponentState state)
    angles = renderPlayerAngles state
    vmgSign = renderVmgSign state
    eqLine = renderEqualityLine state.position state.windOrigin
    movingPart =
      g [ transform (translatePoint state.position) ]
        [ eqLine, angles, vmgSign, playerHull ]
    wake = renderWake state.trail
  in
    g
      [ ]
      [ wake, windShadow, movingPart ]

renderPlayerHull : Float -> Svg
renderPlayerHull heading =
  g
    [ transform (hullRotation heading) ]
    [ hull ]

hullRotation : Float -> String
hullRotation heading =
  let
    r = (180-heading)
  in
    "rotate(" ++ toString r ++ ")"

hull : Svg
hull =
  Svg.path
    [ d "M 5.4664546,8.7755604 C 5.3839679,9.061254 5.2356538,8.8746683 5.1159814,8.3346565 5.0007476,7.8146188 4.9763159,7.7643552 4.7527731,7.5873708 4.4676225,7.3616086 3.541733,7.051912 2.9195012,6.9741688 L 2.7225237,6.9495942 2.3866714,7.4474958 2.0508286,7.9453878 1.1631154,7.9553891 0.27540222,7.9653904 0.20253578,8.0579736 c -0.0926785,0.1177674 -0.19146251,0.1177674 -0.28409337,0 L -0.15442399,7.9653906 -1.0421373,7.9553896 -1.9298505,7.9453886 -2.2657029,7.4474966 -2.6015457,6.949595 -2.7985232,6.97417 c -0.6222317,0.077724 -1.5481212,0.3874398 -1.8332719,0.613202 -0.2236761,0.1770892 -0.2479364,0.2270861 -0.3637607,0.749686 -0.1244158,0.5613764 -0.3065629,0.7527437 -0.3671896,0.3857826 -0.046387,-0.2806644 -0.027908,-8.29461975 0.019431,-8.45277326 0.078486,-0.26201436 0.5078457,-0.37736241 1.6640027,-0.44706653 0.6810011,-0.0410529 0.7200061,-0.0474346 0.7347889,-0.12089161 0.00857,-0.0426721 0.093345,-0.4805184 0.1882717,-0.9730479 0.5755019,-2.9850283 1.84813092,-7.6669491 2.3453944,-8.6285389 0.1651544,-0.3193744 0.77738486,-0.3193744 0.94253925,0 0.49725385,0.9615898 1.76989225,5.6435106 2.34539425,8.6285389 0.094965,0.4925295 0.17968,0.93040437 0.1882621,0.9730479 0.014764,0.0734379 0.053816,0.0798197 0.7347889,0.12089161 1.156157,0.0697232 1.585507,0.18505217 1.6640027,0.44706653 0.055055,0.18363295 0.05715,8.31528906 0.0019,8.50549426 z"
    , fill "white"
    , fillOpacity "0.9"
    , stroke "black"
    , strokeWidth "1"
    , strokeOpacity "0.9"
    ] []

renderWake : List Point -> Svg
renderWake wake =
  let
    pairs = if (isEmpty wake)
      then []
      else map2 (,) wake (tail wake |> Maybe.withDefault []) |> indexedMap (,)
    style = [ stroke "white", strokeWidth "3" ]
    opacityForIndex i =
      0.3 - 0.3 * (toFloat i) / (toFloat (length wake)) |> toString
    renderSegment (i, ab) =
      segment (style ++ [ opacity (opacityForIndex i) ]) ab
  in
    g [ id "playerWake" ] (map renderSegment pairs)

renderWindShadow : OpponentState -> Svg
renderWindShadow {windAngle, windOrigin, position, shadowDirection} =
  let
    arcAngles = [-15, -10, -5, 0, 5, 10, 15]
    endPoints = map (\a -> Geo.add position (fromPolar (windShadowLength, toRadians (shadowDirection + a)))) arcAngles
  in
    polygon
      [ polygonPoints (position :: endPoints)
      , fill "white"
      , opacity "0.2"
      ]
      [ ]

renderEqualityLine : Point -> Float -> Svg
renderEqualityLine (x,y) windOrigin =
  let
    leftSide = (fromPolar (60, toRadians (windOrigin - 90)))
    rightSide = (fromPolar (60, toRadians (windOrigin + 90)))
  in
    segment
      [ stroke "white"
      , strokeWidth "1"
      , strokeDasharray "2,2"
      , opacity "0.5"
      ]
      (leftSide, rightSide)


renderPlayerAngles : PlayerState -> Svg
renderPlayerAngles player =
  let
    windOriginRadians = toRadians (player.heading - player.windAngle)
    -- windMarker = polygon
    --   [ polygonPoints [(0,4),(-3,-5),(3,-5)]
    --   , fill "white"
    --   , opacity "0.5"
    --   , transform <| (translatePoint (fromPolar (30, windOriginRadians))) ++ "rotate(" ++ (toString (player.heading - player.windAngle - 180)) ++ ")"
    --     -- |> rotate (windOriginRadians + pi/2)
    --   ]
    --   [ ]

    windLine = segment
      [ stroke "white", opacity "0.5", strokeDasharray "2,2" ]
      ((0,0), (fromPolar (60, windOriginRadians)))

    absWindAngle = abs (round player.windAngle)

    windAngleText = text'
      [ transform <| (translatePoint (fromPolar (30, windOriginRadians + pi))) ++ "scale(1,-1)"
      , opacity "0.5"
      , fill "black"
      , textAnchor "middle"
      , Svg.Attributes.style (if player.controlMode == FixedAngle then "text-decoration: underline" else "")
      ]
      [ text (toString absWindAngle ++ "°") ]
  in
    g [ ] [ windLine, windAngleText ]


renderVmgSign : PlayerState -> Svg
renderVmgSign player =
  let
    windOriginRadians = toRadians (player.heading - player.windAngle)
    icon = vmgIcon player
    pt = fromPolar (30, windOriginRadians + pi/2)
  in
    g [ transform (translatePoint pt) ]
      [ icon ]


vmgIcon : PlayerState -> Svg
vmgIcon player =
  let a = (abs player.windAngle)
      margin = 3
  in  if a < 90 then
        if | a < player.upwindVmg.angle - margin -> badVmg
           | a > player.upwindVmg.angle + margin -> warnVmg
           | otherwise                           -> goodVmg
      else
        if | a > player.downwindVmg.angle + margin -> badVmg
           | a < player.downwindVmg.angle - margin -> warnVmg
           | otherwise                             -> goodVmg

badVmg : Svg
badVmg =
  rect [ fill "red", stroke "white", x "-4", y "-4", width "8", height "8" ] [ ]

goodVmg : Svg
goodVmg =
  circle [ fill "green", stroke "white", cx "0", cy "0", r "5" ] [ ]

warnVmg : Svg
warnVmg =
  polygon [ fill "orange", stroke "white", points "-4,-4 4,-4 0,4" ] [ ]
