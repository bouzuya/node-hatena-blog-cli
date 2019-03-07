module Main
  ( main
  ) where

import Prelude

import Bouzuya.CommandLineOption as CommandLineOption
import Control.Promise (Promise)
import Control.Promise as Promise
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

foreign import data Client :: Type
foreign import data Response :: Type
foreign import newClient ::
  { apiKey :: String
  , authType :: String -- basic or wsse
  , blogId :: String
  , hatenaId :: String
  } -> Effect Client
foreign import create ::
  forall r. { | r } -> Client -> Effect (Promise Response)
foreign import delete :: String -> Client -> Effect (Promise Response)
foreign import edit ::
  forall r. String -> { | r } -> Client -> Effect (Promise Response)
foreign import list ::
  Client ->
  Effect
    (Promise
      (Array
        { authorName :: String
        , content :: String
        , contentType :: String
        , draft :: Boolean
        , editUrl :: String
        , edited :: String
        , formattedContent :: String
        , htmlUrl :: String
        , id :: String
        , published :: String
        , summary :: String
        , title :: String
        , updated :: String
        }))
foreign import retrieve :: String -> Client -> Effect (Promise Response)

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
main :: Effect Unit
main = do
  configMaybe <- loadConfig
  config <- Maybe.maybe (Exception.throw "invalid config") pure configMaybe
  client <- newClient (Record.merge config { authType: "wsse" })
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
      response <- Promise.toAffE (list client)
      Console.log
        (Array.intercalate
          "\n"
          (map (\{ published, title } -> published <> " " <> title) response))
    _ -> -- TODO
      Console.log command
