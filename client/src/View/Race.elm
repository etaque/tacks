module View.Race (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date
import Date.Format as DateFormat
import Model.Shared exposing (..)
import Route exposing (..)
import Page.Home.Model exposing (..)
import Page.Home.Update exposing (addr)
import View.Utils as Utils exposing (..)


reports : Bool -> List RaceReport -> Html
reports showName reports =
  div
    [ class "row race-reports" ]
    <| if List.isEmpty reports then
        [ div [ class "notice" ] [ text "No races yet!" ] ]
       else
        List.map (raceReportItem showName) reports


raceReportItem : Bool -> RaceReport -> Html
raceReportItem showName report =
  div
    [ class "col-sm-3" ]
    [ div
        [ class "race-report-excerpt" ]
        [ linkTo
            (ShowTrack report.trackId)
            [ class "meta" ]
            [ span
                [ class "start-time" ]
                [ text
                    (DateFormat.format
                      "%e %b. %k:%I"
                      (Date.fromTime report.startTime)
                    )
                ]
            , if showName then
                span
                  [ class "track-name"
                  , title report.trackName
                  ]
                  [ text report.trackName ]
              else
                text ""
            ]
        , ul
            [ class "list-unstyled" ]
            (List.indexedMap raceReportRun report.runs)
        ]
    ]


raceReportRun : Int -> Run -> Html
raceReportRun i run =
  li
    [ class "ranking" ]
    [ span
        [ class "rank" ]
        [ text (toString (i + 1)) ]
    , span
        [ class "handle" ]
        [ text (Maybe.withDefault "anonymous" run.playerHandle)
        ]
    , span
        [ class "time" ]
        [ text (Utils.formatTimer True run.duration) ]
    ]
