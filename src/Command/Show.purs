module Command.Show
  ( command
  ) where

import Prelude

import Client (Client, Entry)
import Client as Client
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console as Console
import Effect.Exception as Exception

command :: Client -> Array String -> Aff Unit
command client [editUrl] = do
  response <- Client.retrieve editUrl client
  Console.log (formatEntry response)
command _ _ = liftEffect (Exception.throw "no edit url")

formatEntry :: Entry -> String
formatEntry { editUrl, htmlUrl, title } =
  "edit url: " <> editUrl <> "\n" <>
  "title: " <> title <> "\n" <>
  "url: " <> htmlUrl
