module Chat.Actions where

import Game (Player)
import Chat.State (..)

type Action = PlayerJoin Player | PlayerLeft Player | NewMessage Message