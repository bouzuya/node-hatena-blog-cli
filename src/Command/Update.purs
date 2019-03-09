module Command.Update
  ( command
  ) where

import Prelude

import Bouzuya.CommandLineOption as CommandLineOption
import Client (Client, Entry)
import Client as Client
import Data.Array as Array
import Data.Either as Either
import Data.Maybe (Maybe(..))
import Data.Maybe as Maybe
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console as Console
import Effect.Exception as Exception
import Node.Encoding as Encoding
import Node.FS.Aff as FS
import Record as Record

command :: Client -> Array String -> Aff Unit
command client args = do
  { arguments, options } <-
    Either.either
      (const (liftEffect (Exception.throw "invalid option")))
      pure
      (CommandLineOption.parse
        { draft: CommandLineOption.booleanOption "draft" (Just 'd') "draft"
        , title:
            CommandLineOption.stringOption
              "title" (Just 't') "<TITLE>" "title" ""
        }
        args)
  editUrl <-
    Maybe.maybe
      (liftEffect (Exception.throw "no edit url"))
      pure
      (Array.index arguments 0)
  file <-
    Maybe.maybe
      (liftEffect (Exception.throw "no file"))
      pure
      (Array.index arguments 0)
  content <- FS.readTextFile Encoding.UTF8 file
  response <-
    Client.edit
      editUrl
      (Record.merge options { content, contentType: "text/x-markdown" })
      client
  Console.log (formatEntry response)

formatEntry :: Entry -> String
formatEntry { published, title } = published <> " " <> title
