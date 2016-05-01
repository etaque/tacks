module Page.ShowTrack.View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Svg
import Svg.Attributes as SvgAttr
import Model.Shared exposing (..)
import Route exposing (..)
import Page.ShowTrack.Model exposing (..)
import Page.ShowTrack.Update exposing (addr)
import View.Utils exposing (..)
import View.Layout as Layout
import View.Race as Race
import Game.Render.Tiles as RenderTiles exposing (lazyRenderTiles)
import Game.Render.Gates exposing (renderOpenGate)
import Game.Render.Players exposing (renderPlayerHull)
import Game.Render.SvgUtils exposing (..)


view : Context -> Model -> Html
view ctx model =
  Layout.siteLayout
    "show-track"
    ctx
    Nothing
    <| Maybe.withDefault
        [ text "" ]
        (Maybe.map (withLiveTrack model) model.liveTrack)


withLiveTrack : Model -> LiveTrack -> List Html
withLiveTrack model ({ track, meta, players } as liveTrack) =
  [ Layout.section
      "blue"
      [ header liveTrack
      ]
  , Layout.section
      "white"
      [ row
          [ div [ class "col-md-8" ] [ courseBlock model.courseControl track.course ]
          , div
              [ class "col-md-4 about" ]
              [ about track
              ]
          ]
      , row
          [ div
              [ class "col-md-5 rankings" ]
              [ h2 [] [ text "Best times" ]
              , rankingsList meta.rankings
              ]
          ]
      ]
  , Layout.section
      "blue"
      [ h1 [ class "align-center" ] [ text "Recent races" ]
      , Race.reports False model.raceReports
      ]
  ]


header : LiveTrack -> Html
header { track, meta, players } =
  row
    [ col'
        10
        [ h1
            []
            [ span
                [ class "track-name" ]
                [ text track.name ]
            , span
                [ class "track-creator" ]
                [ text (" by " ++ playerHandle meta.creator)
                ]
            ]
        ]
    , col'
        2
        [ joinButton track
        ]
    ]


joinButton : Track -> Html
joinButton track =
  linkTo
    (PlayTrack track.id)
    [ class "btn btn-warning btn-block btn-join" ]
    [ text "Join" ]


rankingsList : List Ranking -> Html
rankingsList rankings =
  ul [ class "list-unstyled list-rankings" ] (List.map rankingItem rankings)


about : Track -> Html
about { course } =
  dl'
    -- [ ( "Laps", [ text <| toString course.laps ] )
    -- , ( "Distance", [ text <| toString (course.upwind.y - course.downwind.y), np ] )
    [ ( "Wind speed", [ text <| toString course.windSpeed, abbr' "kn" "Knots" ] )
    , ( "Gusts interval", [ text <| toString course.gustGenerator.interval, abbr' "s" "Seconds" ] )
    , ( "Gusts radius", aboutGustRadius course.gustGenerator )
    , ( "Gusts effect", aboutGustWind course.gustGenerator )
    ]


aboutGustRadius : GustGenerator -> List Html
aboutGustRadius gen =
  [ text (toString gen.radiusBase ++ " +/- " ++ toString gen.radiusVariation)
  , np
  ]


aboutGustWind : GustGenerator -> List Html
aboutGustWind { speedVariation, originVariation } =
  (range speedVariation kn) ++ [ br' ] ++ (range originVariation deg)


range : Range -> Html -> List Html
range { start, end } unitAbbr =
  [ text ("[" ++ toString start)
  , unitAbbr
  , text ".."
  , text (toString end)
  , unitAbbr
  , text "]"
  ]


courseBlock : CourseControl -> Course -> Html
courseBlock control course =
  div
    [ class "course"
    , onMouseOver addr (SetOverCourse True)
    , onMouseOut addr (SetOverCourse False)
    ]
    [ renderCourse control course ]


renderCourse : CourseControl -> Course -> Html
renderCourse { center, scale } course =
  let
    zoom =
      0.5

    w =
      colWidth 8

    h =
      300

    cx =
      (w / 2 / zoom + fst center)

    cy =
      (-h / 2 / zoom + snd center)

    scaleTr =
      "scale(" ++ toString scale ++ ",-" ++ toString scale ++ ")"
  in
    Svg.svg
      [ SvgAttr.width (toString w)
      , SvgAttr.height (toString h)
      ]
      [ Svg.g
          [ SvgAttr.transform (scaleTr ++ (translate cx cy)) ]
          [ (lazyRenderTiles course.grid)
            -- , renderOpenGate course.upwind 0
            -- , renderOpenGate course.downwind 0
          , renderPlayerHull 0 0
          ]
      ]


np : Html
np =
  abbr' "np" "Nautic pixels"


kn : Html
kn =
  abbr' "kn" "Knots"


deg : Html
deg =
  abbr' "°" "Degrees"


br' : Html
br' =
  br [] []
