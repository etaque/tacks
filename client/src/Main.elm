module Main exposing (..)

import Update
import View
import Model
import Navigation
import Route


main : Program Model.Setup Model.Model Model.Msg
main =
    Navigation.programWithFlags
        (Route.parser >> Model.AskRoute)
        { init = Update.init
        , update = Update.update
        , view = View.view
        , subscriptions = Update.subscriptions
        }
