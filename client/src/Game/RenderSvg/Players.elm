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
    hull = g [ transform (translatePoint state.position), opacity "0.5" ] [ renderPlayerHull state.heading state.windAngle ]
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
    playerHull = renderPlayerHull state.heading state.windAngle
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

renderPlayerHull : Float -> Float -> Svg
renderPlayerHull heading windAngle =
  let
    sails = if (abs windAngle) > 130 then [ mainSail, kite ] else [ mainSail ]
    flip = "scale(" ++ toString (abs windAngle / windAngle) ++ ", 1)"
    adjustedSails = g [ transform flip ] sails
  in
    g [ transform (hullRotation heading) ] [ hull, adjustedSails ]

hullRotation : Float -> String
hullRotation heading =
  let
    r = (180 - heading)
  in
    "rotate(" ++ toString r ++ ")"

kite : Svg
kite =
  Svg.path
    [ d "m 0.10669417,-16.214054 c -6.38323627,2.777619 -8.55435517,11.509426 -7.26189907,14.9672275 0.5646828,1.51073708 4.2485734,2.932296 7.19890196,2.20273303 0,-5.20417853 0.06299711,-13.36391553 0.06299711,-17.16996053 z"
    , fill "red"
    , fillOpacity "0.9"
    , stroke "black"
    , strokeWidth "1"
    , strokeOpacity "0.9"
    ] []

mainSail : Svg
mainSail =
  Svg.path
    [ d "M 0.0441942,-1.5917173 C -1.0614896,0.82852063 -0.8611396,3.8386594 -1.0385631,5.822069"
    , stroke "black"
    , strokeWidth "1"
    , strokeLinecap "round"
    , strokeOpacity "0.9"
    ] []

hull : Svg
hull =
  Svg.path
    [ d "m 2.7225237,6.9495942 -0.3358523,0.4979016 -0.3358428,0.497892 -0.8877132,0.010001 -0.88771318,0.010001 -0.0728664,0.092583 c -0.0926785,0.1177674 -0.19146251,0.1177674 -0.28409337,0 L -0.15442399,7.9653906 -1.0421373,7.9553896 -1.9298505,7.9453886 -2.2657029,7.4474966 -2.6015457,6.949595 c -1.2875317,0 -2.7611997,-0.024876 -2.7611997,-0.2267544 0,-0.3138177 -0.027908,-6.29461975 0.019431,-6.45277326 0.078486,-0.26201436 0.5078457,-0.37736241 1.6640027,-0.44706653 0.6810011,-0.0410529 0.7200061,-0.0474346 0.7347889,-0.12089161 0.00857,-0.0426721 0.093345,-0.4805184 0.1882717,-0.9730479 0.5755019,-2.9850283 1.84813092,-7.6669491 2.3453944,-8.6285389 0.1651544,-0.3193744 0.77738486,-0.3193744 0.94253925,0 0.49725385,0.9615898 1.76989225,5.6435106 2.34539425,8.6285389 0.094965,0.4925295 0.17968,0.93040437 0.1882621,0.9730479 0.014764,0.0734379 0.053816,0.0798197 0.7347889,0.12089161 1.156157,0.0697232 1.585507,0.18505217 1.6640027,0.44706653 0.055055,0.18363295 0.0019,6.11500536 0.0019,6.50549426 0,0.1725651 -1.4358401,0.1740326 -2.7435068,0.1740326 z"
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
