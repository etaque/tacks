module Game.Outputs exposing (..)

import Json.Encode as Js
import Model
import Model.Shared exposing (..)
import Page.Game.Model as GamePage
import Game.Models exposing (..)
import Game.Inputs exposing (..)
import Route


type ServerMsg
  = ServerNoOp
  | SendMessage String
  | AddGhost String Player
  | RemoveGhost String
  | StartRace
  | EscapeRace


type LocalMsg
  = LocalNoOp
  | ChatScrollDown


type alias PlayerOutput =
  { state : OpponentState
  , input : KeyboardInput
  , localTime : Float
  }


extractPlayerOutput : Model.Model -> Model.Msg -> Maybe PlayerOutput
extractPlayerOutput model msg =
  let
    keyboardInput =
      case msg of
        Model.PageMsg (Model.GameMsg (GamePage.GameUpdate gameInput)) ->
          Just gameInput.keyboardInput

        _ ->
          Nothing

    gameState =
      case model.location.route of
        Route.PlayTrack _ ->
          model.pages.game.gameState

        _ ->
          Nothing
  in
    Maybe.map (makePlayerOutput keyboardInput) gameState


makePlayerOutput : Maybe KeyboardInput -> GameState -> PlayerOutput
makePlayerOutput keyboardInput gameState =
  let
    realKeyboardInput =
      if gameState.chatting then
        emptyKeyboardInput
      else
        Maybe.withDefault emptyKeyboardInput keyboardInput
  in
    { state = asOpponentState gameState.playerState
    , input = realKeyboardInput
    , localTime = gameState.timers.localTime
    }


getActiveTrack : Model.Model -> Maybe String
getActiveTrack model =
  case model.location.route of
    Route.PlayTrack _ ->
      Maybe.map (.track >> .id) model.pages.game.liveTrack

    _ ->
      Nothing


needChatScrollDown : Model.Msg -> Maybe ()
needChatScrollDown msg =
  case msg of
    Model.PageMsg (Model.GameMsg (GamePage.NewMessage _)) ->
      Just ()

    _ ->
      Nothing


encodeServerMsg : ServerMsg -> Js.Value
encodeServerMsg msg =
  case msg of
    ServerNoOp ->
      tag "ServerNoOp" []

    SendMessage s ->
      tag "SendMessage" [ ( "content", Js.string s ) ]

    AddGhost runId _ ->
      tag "AddGhost" [ ( "runId", Js.string runId ) ]

    RemoveGhost runId ->
      tag "RemoveGhost" [ ( "runId", Js.string runId ) ]

    StartRace ->
      tag "StartRace" []

    EscapeRace ->
      tag "EscapeRace" []


tag : String -> List ( String, Js.Value ) -> Js.Value
tag name fields =
  Js.object <| ( "tag", Js.string name ) :: fields



-- ghosts : Msg -> Maybe Js.Value
-- ghosts msg =
--   case msg of
--     PageMsg (GameMsg ga) ->
--       case ga of
--         GamePage.AddGhost runId _ ->
--           Just
--             <| Js.object
--                 [ ( "tag", Js.string "AddGhost" )
--                 , ( "runId", Js.string runId )
--                 ]
--         GamePage.RemoveGhost runId ->
--           Just
--             <| Js.object
--                 [ ( "tag", Js.string "RemoveGhost" )
--                 , ( "runId", Js.string runId )
--                 ]
--         _ ->
--           Nothing
--     _ ->
--       Nothing
