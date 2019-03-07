module Client
  ( Client
  , Entry
  , list
  , newClient
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
foreign import create ::
  forall r. { | r } -> Client -> Effect (Promise Response)
foreign import delete :: String -> Client -> Effect (Promise Response)
foreign import edit ::
  forall r. String -> { | r } -> Client -> Effect (Promise Response)
foreign import listImpl :: Client -> Effect (Promise (Array Entry))
foreign import retrieve :: String -> Client -> Effect (Promise Response)

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

list :: Client -> Aff (Array Entry)
list = Promise.toAffE <<< listImpl
