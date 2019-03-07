module Main
  ( main
  ) where

import Prelude

import Bouzuya.CommandLineOption as CommandLineOption
import Client (Entry)
import Client as Client
import Data.Array as Array
import Data.Either as Either
import Data.Maybe (Maybe)
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

main :: Effect Unit
main = do
  configMaybe <- loadConfig
  config <- Maybe.maybe (Exception.throw "invalid config") pure configMaybe
  client <- Client.newClient (Record.merge config { authType: "wsse" })
  args <- map (Array.drop 2) Process.argv
  { arguments } <-
    Either.either
      (const (Exception.throw "invalid option"))
      pure
      (CommandLineOption.parse {} args)
  command <-
    Maybe.maybe
      (Exception.throw "no command")
      pure
      (Array.index arguments 0)
  case command of
    "index" -> Aff.launchAff_ do
      response <- Client.list client
      Console.log (Array.intercalate "\n" (map formatEntry response))
    _ -> -- TODO
      Console.log command
