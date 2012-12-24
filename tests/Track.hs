{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax #-}
module Track (auth, noauth) where

import Data.Aeson.Types
import Data.Text.Lazy (Text)
import Network.Lastfm
import Network.Lastfm.Track
import Test.Framework
import Test.Framework.Providers.HUnit

import Common


auth ∷ Request JSON Sign APIKey → Request JSON Sign SessionKey → Text → [Test]
auth ak sk s =
  [ testCase "Track.addTags" testAddTags
  , testCase "Track.ban" testBan
  , testCase "Track.love" testLove
  , testCase "Track.removeTag" testRemoveTag
  , testCase "Track.share" testShare
  , testCase "Track.unban" testUnban
  , testCase "Track.unlove" testUnlove
  , testCase "Track.scrobble" testScrobble
  , testCase "Track.updateNowPlaying" testUpdateNowPlaying
  ]
 where
  testAddTags = check ok . sign s $
    addTags <*> artist "Jefferson Airplane" <*> track "White rabbit" <*> tags ["60s", "awesome"] <*> ak <*> sk

  testBan = check ok . sign s $
    ban <*> artist "Eminem" <*> track "Kim" <*> ak <*> sk

  testLove = check ok . sign s $
    love <*> artist "Gojira" <*> track "Ocean" <*> ak <*> sk

  testRemoveTag = check ok . sign s $
    removeTag <*> artist "Jefferson Airplane" <*> track "White rabbit" <*> tag "awesome" <*> ak <*> sk

  testShare = check ok . sign s $
    share <*> artist "Led Zeppelin" <*> track "When the Levee Breaks" <*> recipient "liblastfm" <* message "Just listen!" <*> ak <*> sk

  testUnban = check ok . sign s $
    unban <*> artist "Eminem" <*> track "Kim" <*> ak <*> sk

  testUnlove = check ok . sign s $
    unlove <*> artist "Gojira" <*> track "Ocean" <*> ak <*> sk

  testScrobble = check ss . sign s $
    scrobble <*> artist "Gojira" <*> track "Ocean" <*> timestamp 1300000000 <*> ak <*> sk

  testUpdateNowPlaying = check np . sign s $
    updateNowPlaying <*> artist "Gojira" <*> track "Ocean" <*> ak <*> sk


noauth ∷ Request JSON Send APIKey → [Test]
noauth ak =
  [ testCase "Track.getBuylinks" testGetBuylinks
  , testCase "Track.getCorrection" testGetCorrection
  , testCase "Track.getFingerprintMetadata" testGetFingerprintMetadata
  , testCase "Track.getInfo" testGetInfo
  , testCase "Track.getShouts" testGetShouts
  , testCase "Track.getSimilar" testGetSimilar
  , testCase "Track.getTags" testGetTags
  , testCase "Track.getTopFans" testGetTopFans
  , testCase "Track.getTopTags" testGetTopTags
  , testCase "Track.search" testSearch
  ]
 where
  testGetBuylinks = check gbl $
    getBuyLinks <*> liftA2 (,) (artist "Pink Floyd") (track "Brain Damage") <*> country "United Kingdom" <*> ak

  testGetCorrection = check gc $
    getCorrection <*> artist "Pink Ployd" <*> track "Brain Damage" <*> ak

  testGetFingerprintMetadata = check gfm $
    getFingerprintMetadata <*> fingerprint 1234 <*> ak

  testGetInfo = check gi $
    getInfo <*> liftA2 (,) (artist "Pink Floyd") (track "Brain Damage") <* username "aswalrus" <*> ak

  testGetShouts = check gsh $
    getShouts <*> liftA2 (,) (artist "Pink Floyd") (track "Comfortably Numb") <* limit 7 <*> ak

  testGetSimilar = check gsi $
    getSimilar <*> liftA2 (,) (artist "Pink Floyd") (track "Comfortably Numb") <* limit 4 <*> ak

  testGetTags = check gt $
    getTags <*> liftA2 (,) (artist "Jefferson Airplane") (track "White Rabbit") <*> user "liblastfm" <*> ak

  testGetTopFans = check gtf $
    getTopFans <*> liftA2 (,) (artist "Pink Floyd") (track "Comfortably Numb") <*> ak

  testGetTopTags = check gtt $
    getTopTags <*> liftA2 (,) (artist "Pink Floyd") (track "Brain Damage") <*> ak

  testSearch = check s' $
    search <*> track "Believe" <* limit 12 <*> ak


gc, gi, gt, ss, np ∷ Value → Parser String
gbl, gfm, gsh, gsi{-, gta-}, gtf, gtt, s' ∷ Value → Parser [String]
gbl o = parseJSON o >>= (.: "affiliations") >>= (.: "downloads") >>= (.: "affiliation") >>= mapM (.: "supplierName")
gc o = parseJSON o >>= (.: "corrections") >>= (.: "correction") >>= (.: "track") >>= (.: "artist") >>= (.: "name")
gfm o = parseJSON o >>= (.: "tracks") >>= (.: "track") >>= mapM (.: "name")
gi o = parseJSON o >>= (.: "track") >>= (.: "userplaycount")
gsh o = parseJSON o >>= (.: "shouts") >>= (.: "shout") >>= mapM (.: "author")
gsi o = parseJSON o >>= (.: "similartracks") >>= (.: "track") >>= mapM (.: "name")
gt o = parseJSON o >>= (.: "tags") >>= (.: "@attr") >>= (.: "track")
gtf o = parseJSON o >>= (.: "topfans") >>= (.: "user") >>= mapM (.: "name")
gtt o = parseJSON o >>= (.: "toptags") >>= (.: "tag") >>= mapM (.: "name")
s' o = parseJSON o >>= (.: "results") >>= (.: "trackmatches") >>= (.: "track") >>= mapM (.: "name")
ss o = parseJSON o >>= (.: "scrobbles") >>= (.: "scrobble") >>= (.: "track") >>= (.: "#text")
np o = parseJSON o >>= (.: "nowplaying") >>= (.: "track") >>= (.: "#text")
