module Main exposing (..)

import Html.App as Html
import Update
import View
import Model
import Navigation
import Route


main : Program Model.Setup
main =
  Navigation.programWithFlags
    (Navigation.makeParser Route.parser)
    { init = Update.init
    , update = Update.update
    , urlUpdate = Update.urlUpdate
    , view = View.view
    , subscriptions = Update.subscriptions
    }
