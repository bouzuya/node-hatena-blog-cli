{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "hatena-blog-cli"
, dependencies =
    [ "aff-promise"
    , "bouzuya-command-line-option-parser"
    , "console"
    , "effect"
    , "node-fs-aff"
    , "node-process"
    , "psci-support"
    , "test-unit"
    ]
, packages =
    ./packages.dhall
}
