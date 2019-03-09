module Main
  ( main
  ) where

import Prelude

import Bouzuya.CommandLineOption as CommandLineOption
import Client (Entry)
import Client as Client
import Command as Command
import Data.Array as Array
import Data.Either as Either
import Data.Enum as Enum
import Data.Maybe (Maybe(..))
import Data.Maybe as Maybe
import Effect (Effect)
import Effect.Aff as Aff
import Effect.Class.Console as Console
import Effect.Exception as Exception
import Foreign.Object as Object
import Node.Process as Process
import Record as Record

type Config =
  { apiKey :: String
  , blogId :: String
  , hatenaId :: String
  }

loadConfig :: Effect (Maybe Config)
loadConfig = do
  env <- Process.getEnv
  pure do
    apiKey <- Object.lookup "HATENA_API_KEY" env
    blogId <- Object.lookup "HATENA_BLOG_ID" env
    hatenaId <- Object.lookup "HATENA_ID" env
    pure { apiKey, blogId, hatenaId }

formatEntry :: Entry -> String
formatEntry { published, title } = published <> " " <> title

help :: String
help =
  Array.intercalate
    "\n"
    ( [ "Usage: hatena-blog [options] <command>"
      , ""
      , "Commands:"
      ] <> (
        map
          (\c -> "  " <> Command.name c <> " " <> Command.description c)
          (Enum.enumFromTo bottom top)
      ) <>
      [ ""
      , "Configs:"
      , "  HATENA_API_KEY your hatena api key. e.g. xxxxxxxxxx"
      , "  HATENA_BLOG_ID your hatena blog id. e.g. bouzuya.hatenablog.com"
      , "  HATENA_ID      your hatena id.      e.g. bouzuya"
      , ""
      , "Options:"
      , "  -h, --help show help"
      ])

main :: Effect Unit
main = do
  args <- map (Array.drop 2) Process.argv
  { arguments, options } <-
    Either.either
      (const (Exception.throw "invalid option"))
      pure
      (CommandLineOption.parseWithOptions
        { greedyArguments: true }
        { help: CommandLineOption.booleanOption "help" (Just 'h') "show help" }
        args)
  if options.help
    then Console.log help
    else do
      command <-
        Maybe.maybe
          (Exception.throw "invalid command")
          pure
          ((Array.index arguments 0) >>= Command.fromString)
      let commandArgs = Array.drop 1 arguments
      configMaybe <- loadConfig
      config <- Maybe.maybe (Exception.throw "invalid config") pure configMaybe
      client <- Client.newClient (Record.merge config { authType: "wsse" })
      Aff.launchAff_ (Command.exec command client commandArgs)
