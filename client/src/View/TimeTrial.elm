module View.TimeTrial exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date
import Date.Format as DateFormat
import Model.Shared exposing (..)
import Route exposing (..)
import View.Utils as Utils exposing (..)
import View.Track as Track


cardView : Player -> LiveTimeTrial -> Html msg
cardView player { track, timeTrial, meta } =
    Utils.linkTo
        Route.PlayTimeTrial
        [ class "time-trial" ]
        [ div
            [ class "row" ]
            [ div
                [ class "col-sm-6 time-trial-left" ]
                [ div
                    [ class "time-trial-header" ]
                    [ div
                        [ class "date" ]
                        [ text ((DateFormat.format "%B %Y" (Date.fromTime timeTrial.creationTime))) ]
                    , h3
                        [ class "name"
                        , title track.name
                        ]
                        [ text track.name ]
                    ]
                ]
            , div
                [ class "col-sm-6 time-trial-right" ]
                [ div
                    [ classList
                        [ ( "time-trial-body", True )
                        , ( "empty", List.isEmpty meta.rankings )
                        ]
                    ]
                    [ Track.rankingsExtract meta.rankings ]
                , if List.length meta.rankings > 0 then
                    div
                        [ class "time-trial-actions" ]
                        [ a
                            [ class "btn-flat" ]
                            [ text <| "See all (" ++ toString (List.length meta.rankings) ++ ")" ]
                        ]
                  else
                    text ""
                ]
            ]
        ]
