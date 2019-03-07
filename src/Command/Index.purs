module Command.Index
  ( command
  ) where

import Prelude

import Client (Client, Entry)
import Client as Client
import Data.Foldable as Foldable
import Effect.Aff (Aff)
import Effect.Class.Console as Console

command :: Client -> Array String -> Aff Unit
command client _ = do
  response <- Client.list client
  Console.log (Foldable.intercalate "\n" (map formatEntry response))

formatEntry :: Entry -> String
formatEntry { published, title } = published <> " " <> title
