module Main
  ( main
  ) where

import Prelude

import Bouzuya.CommandLineOption as CommandLineOption
import Client (Entry)
import Client as Client
import Command.Create as CommandCreate
import Command.Destroy as CommandDestroy
import Command.Index as CommandIndex
import Command.Show as CommandShow
import Command.Update as CommandUpdate
import Data.Array as Array
import Data.Either as Either
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
    [ "Usage: hatena-blog [options] <command>"
    , ""
    , "Commands:"
    , "  create  create an entry"
    , "  destroy destroy an entry"
    , "  index   list entries"
    , "  show    show an entry"
    , "  update  update an entry"
    , ""
    , "Configs:"
    , "  HATENA_API_KEY your hatena api key. e.g. xxxxxxxxxx"
    , "  HATENA_BLOG_ID your hatena blog id. e.g. bouzuya.hatenablog.com"
    , "  HATENA_ID      your hatena id.      e.g. bouzuya"
    , ""
    , "Options:"
    , "  -h, --help show help"
    ]

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
          (Exception.throw "no command")
          pure
          (Array.index arguments 0)
      let commandArgs = Array.drop 1 arguments
      configMaybe <- loadConfig
      config <- Maybe.maybe (Exception.throw "invalid config") pure configMaybe
      client <- Client.newClient (Record.merge config { authType: "wsse" })
      case command of
        "create" -> Aff.launchAff_ (CommandCreate.command client commandArgs)
        "destroy" -> Aff.launchAff_ (CommandDestroy.command client commandArgs)
        "index" -> Aff.launchAff_ (CommandIndex.command client commandArgs)
        "show" -> Aff.launchAff_ (CommandShow.command client commandArgs)
        "update" -> Aff.launchAff_ (CommandUpdate.command client commandArgs)
        _ -> Exception.throw "unknown command"
