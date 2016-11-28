module Page.ShowTimeTrial.Model exposing (..)

import Model.Shared exposing (..)


type alias Model =
    { liveTimeTrial : HttpData LiveTimeTrial }


initial : Model
initial =
    { liveTimeTrial = Loading }


type Msg
    = Load (HttpResult LiveTimeTrial)
