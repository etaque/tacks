module Page.ShowTimeTrial.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Page.ShowTimeTrial.Model exposing (..)
import Model.Shared exposing (..)
import View.Layout as Layout


view : Context -> Model -> Layout.Site Msg
view ctx model =
    Layout.Site
        "show-time-trial"
        Nothing
        (Maybe.map (contentView ctx) (dataMaybe model.liveTimeTrial) |> Maybe.withDefault [ text "Not found" ])
        Nothing


contentView : Context -> LiveTimeTrial -> List (Html Msg)
contentView ctx liveTimeTrial =
    [ Layout.header
        ctx
        []
        [ h1 [] [ text "Time trial" ] ]
    , Layout.section
        [ class "white inside time-trial" ]
        []
    ]
