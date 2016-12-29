module Page.Explore.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dialog
import Model.Shared exposing (..)
import Page.Explore.Model exposing (..)
import View.Layout as Layout exposing (Layout)
import View.Track as Track
import View.Utils as Utils


view : Context -> Model -> Layout Msg
view ctx model =
    Layout
        "explore"
        []
        (Just Layout.Explore)
        [ Layout.header
            ctx
            []
            [ h1 [] [ text "Explore courses" ] ]
        , Layout.section
            [ class "white inside manage-tracks" ]
            [ liveTracks ctx.liveStatus.liveTracks ]
        ]
        (Just (Dialog.view DialogMsg model.dialog (dialogContent model)))


dialogContent : Model -> Dialog.Layout msg
dialogContent model =
    model.showTrackRanking
        |> Maybe.map Track.rankingDialog
        |> Maybe.withDefault Dialog.emptyLayout


liveTracks : List LiveTrack -> Html Msg
liveTracks liveTracks =
    div
        [ class "live-tracks" ]
        [ div
            [ class "row" ]
            (List.map
                (\lt -> div [ class "col-md-4" ] [ Track.liveTrackBlock (ShowTrackRanking lt) lt ])
                (lastLiveTracksFirst liveTracks)
            )
        ]
