module Command.Show
  ( command
  ) where

import Prelude

import Client (Client, Entry)
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
  response <- Client.show editUrl client
  Console.log (formatEntry response)

formatEntry :: Entry -> String
formatEntry { published, title } = published <> " " <> title
