module View.Track exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Route
import View.Utils as Utils
import Dialog


liveTrackBlock : msg -> LiveTrack -> Html msg
liveTrackBlock rankingMsg ({ track, meta, players } as lt) =
    let
        empty =
            List.length players == 0
    in
        div
            [ classList
                [ ( "live-track", True )
                , ( "is-empty", empty )
                ]
            ]
            [ Utils.linkTo
                (Route.PlayTrack track.id)
                [ class "live-track-header" ]
                [ Utils.mIcon "navigate_next" []
                , h3
                    [ class "name", title track.name ]
                    [ text track.name ]
                , div
                    [ class "creator" ]
                    [ text ("by " ++ (Maybe.withDefault "" meta.creator.handle)) ]
                , if empty then
                    text ""
                  else
                    span [ class "live-players" ] [ text (toString (List.length players)) ]
                ]
            , div
                [ class "live-track-body"
                , onClick rankingMsg
                ]
                [ rankingsExtract meta.rankings
                , div
                    [ class "live-track-meta" ]
                    [ Utils.mIcon "fullscreen" []
                    , text <| Utils.pluralize (List.length meta.rankings) "entry" "entries"
                    ]
                ]
            ]


rankingsExtract : List Ranking -> Html msg
rankingsExtract rankings =
    ul
        [ class "list-unstyled list-rankings"
        ]
        (List.take 3 rankings |> List.map Utils.rankingItem)


rankingDialog : LiveTrack -> Dialog.Layout
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
