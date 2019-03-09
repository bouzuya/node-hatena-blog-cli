module Test.Command
  ( tests
  ) where

import Prelude

import Command (Command)
import Command as Command
import Data.Enum as Enum
import Data.Foldable as Foldable
import Data.Maybe (Maybe(..))
import Test.Unit (TestSuite)
import Test.Unit as TestUnit
import Test.Unit.Assert as Assert

tests :: TestSuite
tests = TestUnit.suite "Command" do
  TestUnit.test "Bounded Command" do
    Assert.equal "create" (Command.name (bottom :: Command))
    Assert.equal "update" (Command.name (top :: Command))

  TestUnit.test "BoundedEnum Command" do
    let c1 = bottom :: Command
    Assert.equal (Just c1) (Enum.toEnum (Enum.fromEnum c1))
    let c2 = top :: Command
    Assert.equal (Just c2) (Enum.toEnum (Enum.fromEnum c2))

  TestUnit.test "Enum Command" do
    Assert.equal
      ["create", "destroy", "index", "show", "update"]
      (map Command.name (Enum.enumFromTo bottom top))

  TestUnit.test "Eq Command" do
    pure unit

  TestUnit.test "Ord Command" do
    Assert.assert "<" ((bottom :: Command) < (top :: Command))

  TestUnit.test "Show Command" do
    pure unit

  TestUnit.test "description" do
    Assert.equal
      (Just "create an entry")
      (map Command.description (Command.fromString "create"))

  TestUnit.test "exec" do
    pure unit

  TestUnit.test "fromString" do
    let
      names =
        [ "create"
        , "destroy"
        , "index"
        , "show"
        , "update"
        ]
    Foldable.for_ names \name -> do
      Assert.equal
        (Just name)
        (map Command.name (Command.fromString name))

  TestUnit.test "name" do
    Assert.equal
      (Just "create")
      (map Command.name (Command.fromString "create"))
