module Page.Explore.Update exposing (..)

import Page.Explore.Model exposing (..)
import Response exposing (..)
import Dialog


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.map DialogMsg (Dialog.subscriptions model.dialog)


mount : Res Model Msg
mount =
  res initial Cmd.none


update : Msg -> Model -> Res Model Msg
update msg model =
  case msg of
    ShowTrackRanking liveTrack ->
      Dialog.taggedOpen DialogMsg { model | showTrackRanking = Just liveTrack }
        |> toResponse

    DialogMsg a ->
      Dialog.taggedUpdate DialogMsg a model
        |> toResponse

    NoOp ->
      res model Cmd.none
