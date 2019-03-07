module Main
  ( main
  ) where

import Prelude

import Bouzuya.CommandLineOption as CommandLineOption
import Control.Promise (Promise)
import Data.Array as Array
import Data.Either as Either
import Data.Maybe as Maybe
import Effect (Effect)
import Effect.Console as Console
import Effect.Exception as Exception
import Node.Process as Process

foreign import data Client :: Type
foreign import data Response :: Type
foreign import newClient :: forall r. { | r } -> Effect Client
foreign import create ::
  forall r. { | r } -> Client -> Effect (Promise Response)
foreign import delete :: String -> Client -> Effect (Promise Response)
foreign import edit ::
  forall r. String -> { | r } -> Client -> Effect (Promise Response)
foreign import list :: Client -> Effect (Promise Response)
foreign import retrieve :: String -> Client -> Effect (Promise Response)

main :: Effect Unit
main = do
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
  Console.log command
