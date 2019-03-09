module Command
  ( Command
  , description
  , exec
  , fromString
  , name
  ) where

import Prelude

import Client (Client)
import Command.Create as CommandCreate
import Command.Destroy as CommandDestroy
import Command.Index as CommandIndex
import Command.Show as CommandShow
import Command.Update as CommandUpdate
import Data.Array as Array
import Data.Enum (class BoundedEnum, class Enum)
import Data.Enum as Enum
import Data.Foldable as Foldable
import Data.Maybe (Maybe)
import Data.Maybe as Maybe
import Effect.Aff (Aff)
import Partial.Unsafe as Unsafe

data Command =
  Command String String (Client -> Array String -> Aff Unit)

instance boundedCommand :: Bounded Command where
  bottom = Unsafe.unsafePartial (Maybe.fromJust (Array.head commands))
  top  = Unsafe.unsafePartial (Maybe.fromJust (Array.last commands))

instance boundedEnumCommand :: BoundedEnum Command where
  cardinality = Enum.Cardinality (Array.length commands)
  fromEnum a =
    Unsafe.unsafePartial (Maybe.fromJust (Array.findIndex (eq a) commands))
  toEnum = Array.index commands

instance enumCommand :: Enum Command where
  pred = Enum.toEnum <<< (_ - 1) <<< Enum.fromEnum
  succ = Enum.toEnum <<< (_ + 1) <<< Enum.fromEnum

instance eqCommand :: Eq Command where
  eq (Command a _ _) (Command b _ _) = eq a b

instance ordCommand :: Ord Command where
  compare = comparing Enum.fromEnum

instance showCommand :: Show Command where
  show (Command n _ _) = "(Command " <> n <> ")"

commands :: Array Command
commands =
  Array.sortWith
    name
    [ Command "create" "create an entry" CommandCreate.command
    , Command "destroy" "delete an entry" CommandDestroy.command
    , Command "index" "list entries" CommandIndex.command
    , Command "show" "show an entry" CommandShow.command
    , Command "update" "update an entry" CommandUpdate.command
    ]

description :: Command -> String
description (Command _ d _) = d

exec :: Command -> Client -> Array String -> Aff Unit
exec (Command _ _ f) = f

fromString :: String -> Maybe Command
fromString s = Foldable.find ((eq s) <<< name) commands

name :: Command -> String
name (Command n _ _) = n
