module Client
  ( Client
  , Entry
  , create
  , delete
  , edit
  , list
  , newClient
  , retrieve
  ) where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Effect (Effect)
import Effect.Aff (Aff)

type EntryParams =
  { content :: String
  -- 'text/html' | 'text/x-hatena-syntax' | 'text/x-markdown'
  , contentType :: String
  , draft :: Boolean
  , title :: String
  -- updated?: string;
  -- categories?: string[];
  }
foreign import data Client :: Type
foreign import newClient ::
  { apiKey :: String
  , authType :: String -- basic or wsse
  , blogId :: String
  , hatenaId :: String
  } -> Effect Client
foreign import createImpl :: EntryParams -> Client -> Effect (Promise Entry)
foreign import deleteImpl :: String -> Client -> Effect (Promise Unit)
foreign import editImpl ::
  String -> EntryParams -> Client -> Effect (Promise Entry)
foreign import listImpl :: Client -> Effect (Promise (Array Entry))
foreign import retrieveImpl :: String -> Client -> Effect (Promise Entry)

type Entry =
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
  }

create :: EntryParams -> Client -> Aff Entry
create params client = Promise.toAffE (createImpl params client)

delete :: String -> Client -> Aff Unit
delete editUrl client = Promise.toAffE (deleteImpl editUrl client)

edit :: String -> EntryParams -> Client -> Aff Entry
edit editUrl params client = Promise.toAffE (editImpl editUrl params client)

list :: Client -> Aff (Array Entry)
list = Promise.toAffE <<< listImpl

retrieve :: String -> Client -> Aff Entry
retrieve editUrl client = Promise.toAffE (retrieveImpl editUrl client)
