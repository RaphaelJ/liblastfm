-- | Auth API module
{-# OPTIONS_HADDOCK prune #-}
module Network.Lastfm.API.Auth
  ( getMobileSession, getSession, getToken
  , getAuthorizeTokenLink
  ) where

import Data.Functor ((<$>))
import Network.Lastfm

-- | Create a web service session for a user. Used for authenticating a user when the password can be inputted by the user. Only suitable for standalone mobile devices.
--
-- More: <http://www.last.fm/api/show/auth.getMobileSession>
getMobileSession ∷ Username → APIKey → AuthToken → Lastfm SessionKey
getMobileSession username apiKey token = simple <$> callAPI JSON [(#) (Method "auth.getMobileSession"), (#) username, (#) token, (#) apiKey]

-- | Fetch a session key for a user.
--
-- More: <http://www.last.fm/api/show/auth.getSession>
getSession ∷ APIKey → Token → Secret → Lastfm SessionKey
getSession apiKey token secret = simple <$> callAPIsigned JSON secret [(#) (Method "auth.getSession"), (#) apiKey, (#) token]

-- | Fetch an unathorized request token for an API account.
--
-- More: <http://www.last.fm/api/show/auth.getToken>
getToken ∷ APIKey → Lastfm Token
getToken apiKey = simple <$> callAPI JSON [(#) (Method "auth.getToken"), (#) apiKey]

-- | Construct the link to authorize token.
getAuthorizeTokenLink ∷ APIKey → Token → String
getAuthorizeTokenLink apiKey token = "http://www.last.fm/api/auth/?api_key=" ++ value apiKey ++ "&token=" ++ value token