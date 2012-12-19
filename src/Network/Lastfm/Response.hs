{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax #-}
{-# LANGUAGE ViewPatterns #-}
-- | Request sending and Response parsing
module Network.Lastfm.Response
  ( -- * Sign Request
    -- $sign
    Secret, sign
    -- * Get Response
  , lastfm
  ) where

import Control.Applicative
import Data.Monoid

import           Data.Default (Default(..))
import           Data.Digest.Pure.MD5 (md5)
import qualified Data.Map as M
import           Data.Text.Lazy (Text)
import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.Encoding as T
import qualified Network.HTTP.Conduit as C

import Network.Lastfm.Internal
import Network.Lastfm.Request


-- $sign
--
-- Signing is important part of every
-- authentication requiring API request.
-- Basically, every such request is appended
-- with md5 footprint of its arguments as
-- described at <http://www.last.fm/api/authspec#8>


-- | Application secret
type Secret = Text


-- | Sign 'Request' with 'Secret'
sign ∷ Secret → Request f Sign Ready → Request f Send Ready
sign s = approve . (<> signature)
 where
  signature = wrap $ \r@R { query = q } →
    r { query = M.insert "api_sig" (signer (foldr M.delete q ["format", "callback"])) q }

  signer = T.pack . show . md5 . T.encodeUtf8 . M.foldrWithKey(\k v xs → k <> v <> xs) s


-- | Send Request and parse Response
lastfm ∷ Default (R f Send Ready) ⇒ Request f Send Ready → IO (Response f)
lastfm (($ def) . unwrap → request) =
  parse request <$> C.withManager (\m → C.parseUrl (render request) >>= \url →
    C.responseBody <$> C.httpLbs (url { C.method = method request, C.responseTimeout = Just 10000000 }) m)


approve ∷ Request f Sign Ready → Request f Send Ready
approve = coerce
{-# INLINE approve #-}
