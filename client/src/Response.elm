module Response exposing (..)

import Model.Event exposing (Event)


type alias Response model msg =
  { model : model
  , cmd : Cmd msg
  , event : Maybe Event
  }


type alias Res model msg =
  Response model msg


res : model -> Cmd msg -> Response model msg
res model cmd =
  Response model cmd Nothing


mapModel : (m -> m') -> Response m a -> Response m' a
mapModel onModel =
  mapBoth onModel identity


mapCmd : (a -> a') -> Response m a -> Response m a'
mapCmd onCmd =
  mapBoth identity onCmd


mapBoth : (m -> m') -> (a -> a') -> Response m a -> Response m' a'
mapBoth onModel onCmd ({model, cmd} as r) =
  { r
    | model = onModel model
    , cmd = Cmd.map onCmd cmd
  }


addCmd : Cmd a -> Response m a -> Response m a
addCmd cmd r =
  let
    batched =
      Cmd.batch [ cmd, r.cmd ]
  in
    { r | cmd = batched }


withEvent : Event -> Response m a -> Response m a
withEvent event r =
  { r | event = Just event }


noEvent : Response m a -> Response m a
noEvent r =
  { r | event = Nothing }


joinEvent : Event -> ( m, Cmd a ) -> Response m a
joinEvent event ( m, cmd ) =
  res m cmd
    |> withEvent event


pure : ( model, Cmd msg ) -> Response model msg
pure ( model, cmd ) =
  res model cmd
