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
import Dialog


cardView : msg -> Player -> LiveTimeTrial -> Html msg
cardView rankingMsg player ({ track, timeTrial, meta } as ltt) =
    div
        [ class "time-trial" ]
        [ div
            [ class "row" ]
            [ div
                [ class "col-sm-6 time-trial-left" ]
                [ Utils.linkTo
                    Route.PlayTimeTrial
                    [ class "time-trial-header" ]
                    [ Utils.mIcon "play_circle_filled" []
                    , div
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
                    , onClick rankingMsg
                    ]
                    [ Track.rankingsExtract meta.rankings
                    , if List.length meta.rankings > 0 then
                        div
                            [ class "live-track-meta" ]
                            [ Utils.mIcon "fullscreen" []
                            , text <| Utils.pluralize (List.length meta.rankings) "entry" "entries"
                            ]
                      else
                        text ""
                    ]
                ]
            ]
        ]


rankingDialog : LiveTimeTrial -> Dialog.Layout
rankingDialog { track, meta } =
    { header = [ Dialog.title track.name ]
    , body =
        [ ul
            [ class "list-unstyled list-rankings" ]
            (List.map Utils.rankingItem meta.rankings)
        ]
    , footer =
        [ text <| Utils.pluralize (List.length meta.rankings) "entry" "entries"
        ]
    }
