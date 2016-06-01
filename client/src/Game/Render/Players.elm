module Game.Render.Players exposing (..)

import Game.Core exposing (..)
import Game.Geo as Geo
import Game.Models exposing (..)
import Model.Shared exposing (..)
import Game.Render.SvgUtils exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import List exposing (..)


renderPlayers : GameState -> Svg msg
renderPlayers ({ playerState, opponents, ghosts, course, center } as gameState) =
  g
    [ class "players" ]
    [ renderOpponents opponents
    , renderGhosts ghosts
    , renderPlayer course playerState
    ]


renderOpponents : List Opponent -> Svg msg
renderOpponents opponents =
  g [ class "opponents" ] (map renderOpponent opponents)


renderOpponent : Opponent -> Svg msg
renderOpponent { state, player } =
  let
    hull =
      g
        [ transform (translatePoint state.position)
        , opacity "0.6"
        ]
        [ renderPlayerHull state.heading state.windAngle ]

    shadow =
      renderWindShadow state

    name =
      text'
        [ textAnchor "middle"
        , transform <| (translatePoint (Geo.add state.position ( 0, -25 ))) ++ "scale(1,-1)"
        , opacity "0.3"
        ]
        [ text (Maybe.withDefault "Anonymous" player.handle) ]
  in
    g [ class "opponent" ] [ shadow, hull, name ]


renderGhosts : List Ghost -> Svg msg
renderGhosts ghosts =
  g [ class "ghosts" ] (map renderGhost ghosts)


renderGhost : Ghost -> Svg msg
renderGhost ghost =
  let
    hull =
      g
        [ transform (translatePoint ghost.position)
        , opacity "0.4"
        ]
        [ renderPlayerHull ghost.heading 0 ]

    name =
      text'
        [ textAnchor "middle"
        , transform <| (translatePoint (Geo.add ghost.position ( 0, -25 ))) ++ "scale(1,-1)"
        , opacity "0.2"
        ]
        [ text (Maybe.withDefault "Anonymous" ghost.handle) ]
  in
    g [ class "ghost" ] [ hull, name ]


renderPlayer : Course -> PlayerState -> Svg msg
renderPlayer course state =
  let
    playerHull =
      renderPlayerHull state.heading state.windAngle

    windShadow =
      renderWindShadow (asOpponentState state)

    angles =
      renderPlayerAngles state

    nextGateLine =
      renderNextGateLine course state

    vmgSign =
      renderVmgSign state

    movingPart =
      g
        [ transform (translatePoint state.position) ]
        [ angles, playerHull, vmgSign ]

    wake =
      renderWake state.trail
  in
    g
      [ class "player" ]
      [ wake, windShadow, nextGateLine, movingPart ]


renderPlayerHull : Float -> Float -> Svg msg
renderPlayerHull heading windAngle =
  let
    sails =
      if (abs windAngle) > 130 then
        [ mainSail, kite ]
      else
        [ mainSail ]

    xScale =
      if windAngle /= 0 then
        abs windAngle / windAngle
      else
        1

    flip =
      "scale(" ++ toString xScale ++ ", 1)"

    adjustedSails =
      g [ transform flip ] sails
  in
    g [ transform (hullRotation heading) ] [ hull, adjustedSails ]


hullRotation : Float -> String
hullRotation heading =
  rotate_ (180 - heading) 0 0


kite : Svg msg
kite =
  Svg.path
    [ d "m 0.10669417,-16.214054 c -6.38323627,2.777619 -8.55435517,11.509426 -7.26189907,14.9672275 0.5646828,1.51073708 4.2485734,2.932296 7.19890196,2.20273303 0,-5.20417853 0.06299711,-13.36391553 0.06299711,-17.16996053 z"
    , fill "white"
    , fillOpacity "0.9"
    , stroke "black"
    , strokeWidth "1"
    , strokeOpacity "0.9"
    , class "kite"
    ]
    []


mainSail : Svg msg
mainSail =
  Svg.path
    [ d "M 0.0441942,-1.5917173 C -1.0614896,0.82852063 -0.8611396,3.8386594 -1.0385631,5.822069"
    , stroke "grey"
    , strokeWidth "1"
    , strokeLinecap "round"
    , strokeOpacity "0.9"
    , class "main-sail"
    ]
    []


hull : Svg msg
hull =
  Svg.path
    [ d "m 2.7225237,6.9495942 -0.3358523,0.4979016 -0.3358428,0.497892 -0.8877132,0.010001 -0.88771318,0.010001 -0.0728664,0.092583 c -0.0926785,0.1177674 -0.19146251,0.1177674 -0.28409337,0 L -0.15442399,7.9653906 -1.0421373,7.9553896 -1.9298505,7.9453886 -2.2657029,7.4474966 -2.6015457,6.949595 c -1.2875317,0 -2.7611997,-0.024876 -2.7611997,-0.2267544 0,-0.3138177 -0.027908,-6.29461975 0.019431,-6.45277326 0.078486,-0.26201436 0.5078457,-0.37736241 1.6640027,-0.44706653 0.6810011,-0.0410529 0.7200061,-0.0474346 0.7347889,-0.12089161 0.00857,-0.0426721 0.093345,-0.4805184 0.1882717,-0.9730479 0.5755019,-2.9850283 1.84813092,-7.6669491 2.3453944,-8.6285389 0.1651544,-0.3193744 0.77738486,-0.3193744 0.94253925,0 0.49725385,0.9615898 1.76989225,5.6435106 2.34539425,8.6285389 0.094965,0.4925295 0.17968,0.93040437 0.1882621,0.9730479 0.014764,0.0734379 0.053816,0.0798197 0.7347889,0.12089161 1.156157,0.0697232 1.585507,0.18505217 1.6640027,0.44706653 0.055055,0.18363295 0.0019,6.11500536 0.0019,6.50549426 0,0.1725651 -1.4358401,0.1740326 -2.7435068,0.1740326 z"
    , fill "white"
    , fillOpacity "0.9"
    , stroke "black"
    , strokeWidth "1"
    , strokeOpacity "0.9"
    , class "hull"
    ]
    []


renderWake : List Point -> Svg msg
renderWake wake =
  let
    pairs =
      if (isEmpty wake) then
        []
      else
        map2 (,) wake (tail wake |> Maybe.withDefault []) |> indexedMap (,)

    style =
      [ stroke "white", strokeWidth "3" ]

    opacityForIndex i =
      0.3 - 0.3 * (toFloat i) / (toFloat (length wake)) |> toString

    renderSegment ( i, ab ) =
      segment (style ++ [ opacity (opacityForIndex i) ]) ab
  in
    g [ id "playerWake" ] (map renderSegment pairs)


renderWindShadow : OpponentState -> Svg msg
renderWindShadow { windAngle, windOrigin, position, shadowDirection } =
  let
    arcAngles =
      [ -15, -10, -5, 0, 5, 10, 15 ]

    endPoints =
      map (\a -> Geo.add position (fromPolar ( windShadowLength, toRadians (shadowDirection + a) ))) arcAngles
  in
    polygon
      [ polygonPoints (position :: endPoints)
      , fill "white"
      , opacity "0.2"
      ]
      []


renderNextGateLine : Course -> PlayerState -> Svg msg
renderNextGateLine course state =
  let
    length =
      100

    maybeGatePos =
      Maybe.map .center state.nextGate

    ifFarEnough gatePos =
      if (Geo.distance state.position gatePos) > length * 2.5 then
        Just gatePos
      else
        Nothing

    renderLine gatePos =
      let
        a =
          Geo.angleBetween state.position gatePos

        p1 =
          Geo.add state.position (Geo.rotateDeg a 50)

        p2 =
          Geo.add state.position (Geo.rotateDeg a 150)
      in
        segment
          [ stroke "white"
          , strokeDasharray "4,4"
          , opacity "0.5"
          , markerEnd "url(#whiteFullArrow)"
          ]
          ( p1, p2 )
  in
    Maybe.map renderLine (maybeGatePos `Maybe.andThen` ifFarEnough)
      |> Maybe.withDefault empty


renderPlayerAngles : PlayerState -> Svg msg
renderPlayerAngles player =
  let
    windOrigin =
      player.heading - player.windAngle

    windMarker =
      g
        [ transform <| translate 0 -40 ++ rotate_ (180 - windOrigin) 0 40
        , opacity "0.9"
        ]
        [ renderWindArrow ]

    leftSide =
      (fromPolar ( 60, toRadians (player.windOrigin - 90) ))

    rightSide =
      (fromPolar ( 60, toRadians (player.windOrigin + 90) ))

    eqLine =
      segment
        [ stroke "white"
        , strokeWidth "1"
        , opacity "0.5"
        ]
        ( leftSide, rightSide )

    vmgLines =
      g
        [ opacity "0.5" ]
        [ renderVmgLine -player.upwindVmg.angle
        , renderVmgLine player.upwindVmg.angle
        , renderVmgLine -player.downwindVmg.angle
        , renderVmgLine player.downwindVmg.angle
        ]

    windLine =
      segment
        [ stroke "white", opacity "0.5" ]
        ( ( 0, 0 ), Geo.rotateDeg windOrigin 35 )

    absWindAngle =
      abs (round player.windAngle)

    windAngleText =
      text'
        [ transform <| (translatePoint (Geo.rotateDeg (windOrigin + 180) 30)) ++ "scale(1,-1)"
        , opacity "0.5"
        , fill "black"
        , textAnchor "middle"
        , Svg.Attributes.style
            (if player.controlMode == FixedAngle then
              "text-decoration: underline"
             else
              ""
            )
        ]
        [ text (toString absWindAngle ++ "°") ]
  in
    g
      []
      [ eqLine
      , windLine
      , windMarker
      , vmgLines
      , windAngleText
      ]


renderWindArrow : Svg msg
renderWindArrow =
  Svg.path
    [ d "M 0,0 3,-12 0,-10 -3,-12 Z"
    , fill "white"
    ]
    []


renderVmgLine : Float -> Svg msg
renderVmgLine a =
  segment
    [ stroke "white", opacity "0.8" ]
    ( ( 0, 0 ), (Geo.rotateDeg a 30) )


renderVmgSign : PlayerState -> Svg msg
renderVmgSign player =
  let
    windOriginRadians =
      toRadians (player.heading - player.windAngle)

    icon =
      vmgIcon player

    pt =
      fromPolar ( 30, windOriginRadians + pi / 2 )
  in
    g
      [ transform (translatePoint pt) ]
      [ icon ]


vmgIcon : PlayerState -> Svg msg
vmgIcon player =
  let
    a =
      (abs player.windAngle)

    margin =
      3
  in
    if a < 90 then
      if a < player.upwindVmg.angle - margin then
        badVmg
      else if a > player.upwindVmg.angle + margin then
        warnVmg
      else
        goodVmg
    else if a > player.downwindVmg.angle + margin then
      badVmg
    else if a < player.downwindVmg.angle - margin then
      warnVmg
    else
      goodVmg


badVmg : Svg msg
badVmg =
  rect [ fill "red", stroke "white", x "-4", y "-4", width "8", height "8" ] []


goodVmg : Svg msg
goodVmg =
  circle [ fill "green", stroke "white", cx "0", cy "0", r "5" ] []


warnVmg : Svg msg
warnVmg =
  polygon [ fill "orange", stroke "white", points "-4,-4 4,-4 0,4" ] []
