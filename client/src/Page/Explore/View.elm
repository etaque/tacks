module Page.Explore.View exposing (..)

import Html.App exposing (map)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dialog
import Model.Shared exposing (..)
import Page.Explore.Model exposing (..)
import View.Layout as Layout
import View.Track as Track
import View.Utils as Utils


view : Context -> Model -> Layout.Site Msg
view ctx model =
  Layout.Site
    "explore"
    (Just Layout.Explore)
    [ Layout.header
        ctx
        []
        [ h1 [] [ text "All tracks" ] ]
    , Layout.section
        [ class "white inside manage-tracks" ]
        [ liveTracks ctx.liveStatus.liveTracks ]
    ]
    (Just (Dialog.view DialogMsg model.dialog (dialogContent model)))


dialogContent : Model -> Dialog.Layout
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
        (List.map (\lt -> div [ class "col-md-4" ] [ Track.liveTrackBlock rankingClickHandler lt ]) liveTracks)
    ]


rankingClickHandler : LiveTrack -> Attribute Msg
rankingClickHandler liveTrack =
  Utils.onButtonClick (ShowTrackRanking liveTrack)
