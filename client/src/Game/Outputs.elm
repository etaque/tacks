module Game.Outputs (..) where

import Json.Encode as Js
import TransitRouter exposing (getRoute)
import Model
import Model.Shared exposing (..)
import Page.Game.Model as GamePage
import Game.Models exposing (..)
import Game.Inputs exposing (..)
import Route


type ServerAction
  = ServerNoOp
  | SendMessage String
  | AddGhost String Player
  | RemoveGhost String
  | StartRace
  | EscapeRace


type LocalAction
  = LocalNoOp
  | ChatScrollDown


serverMailbox : Signal.Mailbox ServerAction
serverMailbox =
  Signal.mailbox ServerNoOp


serverAddress : Signal.Address ServerAction
serverAddress =
  serverMailbox.address


type alias PlayerOutput =
  { state : OpponentState
  , input : KeyboardInput
  , localTime : Float
  }


extractPlayerOutput : Model.Model -> Model.Action -> Maybe PlayerOutput
extractPlayerOutput model action =
  let
    keyboardInput =
      case action of
        Model.PageAction (Model.GameAction (GamePage.GameUpdate gameInput)) ->
          Just gameInput.keyboardInput

        _ ->
          Nothing

    gameState =
      case getRoute model of
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
  case getRoute model of
    Route.PlayTrack _ ->
      Maybe.map (.track >> .id) model.pages.game.liveTrack

    _ ->
      Nothing



needChatScrollDown : Model.Action -> Maybe ()
needChatScrollDown action =
  case action of
    Model.PageAction (Model.GameAction (GamePage.NewMessage _)) ->
      Just ()
    _ ->
      Nothing


encodeServerAction : ServerAction -> Js.Value
encodeServerAction action =
  case action of
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



-- ghosts : Action -> Maybe Js.Value
-- ghosts action =
--   case action of
--     PageAction (GameAction ga) ->
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
