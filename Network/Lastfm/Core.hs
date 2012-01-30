module Network.Lastfm.Core
  ( callAPI, tagContent, tagContents
  ) where

import Control.Monad (join, liftM)
import Control.Applicative ((<$>))
import Data.Function (on)
import Data.Digest.Pure.MD5 (md5)
import Data.List (sortBy)
import Data.URLEncoded (urlEncode, export)
import Network.Curl hiding (Content)
import System.Directory (getHomeDirectory)
import System.FilePath ((</>))
import Text.XML.Light

import qualified Data.ByteString.Lazy.Char8 as BS

type Key = String
type Value = String
type Secret = String
type Sign = String

callAPI :: [(Key, Value)] -> IO [Element]
callAPI as = withCurlDo $ do
               directoru <- getHomeDirectory
               secret <- init <$> readFile (directoru </> ".lastfm")
               print secret
               handle <- initialize
               response <- liftM (onlyElems . parseXML . respBody)
                            (do_curl_ handle
                                      "http://ws.audioscrobbler.com/2.0/?"
                                      [ CurlPostFields . map (export . urlEncode) $ (("api_sig", sign secret as) : as) ]
                                      :: IO CurlResponse)
               reset handle
               case tagContent "error" response of
                 Just s  -> error s
                 Nothing -> return response
  where sign :: Secret -> [(Key, Value)] -> Sign
        -- ^ Each API call (a little exception for getToken) should be signed.
        -- Algorithm description can be found at http://www.lastfm.ru/api/authspec Section 8
        sign secret = show . md5 . BS.pack . (++ secret) . concatMap (uncurry (++)) . sortBy (compare `on` fst)

tagContent :: String -> [Element] -> Maybe String
tagContent tag elements = strContent <$> firstTag elements
  where firstTag :: [Element] -> Maybe Element
        firstTag = maybeHead . concatMap (findElements . unqual $ tag)
          where maybeHead :: [a] -> Maybe a
                maybeHead [] = Nothing
                maybeHead xs = Just $ head xs

tagContents :: String -> [Element] -> [String]
tagContents tag = map strContent <$> concatMap (findElements . unqual $ tag)
