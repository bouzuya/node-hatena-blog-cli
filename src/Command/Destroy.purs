module Command.Destroy
  ( command
  ) where

import Prelude

import Client (Client)
import Client as Client
import Data.Array as Array
import Data.Maybe as Maybe
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console as Console
import Effect.Exception as Exception

command :: Client -> Array String -> Aff Unit
command client args = do
  editUrl <-
    Maybe.maybe
      (liftEffect (Exception.throw "no edit url"))
      pure
      (Array.index args 0)
  Client.destroy editUrl client
  Console.log "deleted"
