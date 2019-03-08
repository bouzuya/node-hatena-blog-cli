module Client
  ( Client
  , Entry
  , create
  , destroy
  , list
  , newClient
  , show
  ) where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Effect (Effect)
import Effect.Aff (Aff)

foreign import data Client :: Type
foreign import data Response :: Type
foreign import newClient ::
  { apiKey :: String
  , authType :: String -- basic or wsse
  , blogId :: String
  , hatenaId :: String
  } -> Effect Client
foreign import createImpl ::
  { content :: String
  -- 'text/html' | 'text/x-hatena-syntax' | 'text/x-markdown'
  , contentType :: String
  , draft :: Boolean
  , title :: String
  -- updated?: string;
  -- categories?: string[];
  }
  -> Client
  -> Effect (Promise Entry)
foreign import delete :: String -> Client -> Effect (Promise Unit)
foreign import edit ::
  forall r. String -> { | r } -> Client -> Effect (Promise Response)
foreign import listImpl :: Client -> Effect (Promise (Array Entry))
foreign import retrieve :: String -> Client -> Effect (Promise Entry)

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

create ::
  { content :: String
  -- 'text/html' | 'text/x-hatena-syntax' | 'text/x-markdown'
  , contentType :: String
  , draft :: Boolean
  , title :: String
  -- updated?: string;
  -- categories?: string[];
  } -> Client -> Aff Entry
create params client = Promise.toAffE (createImpl params client)

destroy :: String -> Client -> Aff Unit
destroy editUrl client = Promise.toAffE (delete editUrl client)

list :: Client -> Aff (Array Entry)
list = Promise.toAffE <<< listImpl

show :: String -> Client -> Aff Entry
show editUrl client = Promise.toAffE (retrieve editUrl client)
