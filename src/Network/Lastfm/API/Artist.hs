-- | Artist API module
{-# OPTIONS_HADDOCK prune #-}
module Network.Lastfm.API.Artist
  ( addTags, getCorrection, getEvents, getImages, getInfo
  , getPastEvents, getPodcast, getShouts, getSimilar, getTags, getTopAlbums
  , getTopFans, getTopTags, getTopTracks, removeTag, search, share, shout
  ) where

import Control.Arrow ((|||))
import Network.Lastfm

-- | Tag an album using a list of user supplied tags.
--
-- More: <http://www.last.fm/api/show/artist.addTags>
addTags ∷ Artist → [Tag] → APIKey → SessionKey → Secret → Lastfm Response
addTags artist tags apiKey sessionKey secret = callAPIsigned XML secret
  [ (#) (Method "artist.addTags")
  , (#) artist
  , (#) tags
  , (#) apiKey
  , (#) sessionKey
  ]

-- | Use the last.fm corrections data to check whether the supplied artist has a correction to a canonical artist
--
-- More: <http://www.last.fm/api/show/artist.getCorrection>
getCorrection ∷ Artist → APIKey → Lastfm Response
getCorrection artist apiKey = callAPI XML
  [ (#) (Method "artist.getCorrection")
  , (#) artist
  , (#) apiKey
  ]

-- | Get a list of upcoming events for this artist.
--
-- More: <http://www.last.fm/api/show/artist.getEvents>
getEvents ∷ Either Artist Mbid → Maybe Autocorrect → Maybe Page → Maybe Limit → Maybe FestivalsOnly → APIKey → Lastfm Response
getEvents a autocorrect page limit festivalsOnly apiKey = callAPI XML $
  target a ++
  [ (#) (Method "artist.getEvents")
  , (#) autocorrect
  , (#) page
  , (#) limit
  , (#) festivalsOnly
  , (#) apiKey
  ]

-- | Get Images for this artist in a variety of sizes.
--
-- More: <http://www.last.fm/api/show/artist.getImages>
getImages ∷ Either Artist Mbid → Maybe Autocorrect → Maybe Page → Maybe Limit → Maybe Order → APIKey → Lastfm Response
getImages a autocorrect page limit order apiKey = callAPI XML $
  target a ++
  [ (#) (Method "artist.getImages")
  , (#) autocorrect
  , (#) page
  , (#) limit
  , (#) order
  , (#) apiKey
  ]

-- | Get the metadata for an artist. Includes biography.
--
-- More: <http://www.last.fm/api/show/artist.getInfo>
getInfo ∷ Either Artist Mbid → Maybe Autocorrect → Maybe Language → Maybe Username → APIKey → Lastfm Response
getInfo a autocorrect language username apiKey = callAPI XML $
  target a ++
  [ (#) (Method "artist.getInfo")
  , (#) autocorrect
  , (#) language
  , (#) username
  , (#) apiKey
  ]

-- | Get a paginated list of all the events this artist has played at in the past.
--
-- More: <http://www.last.fm/api/show/artist.getPastEvents>
getPastEvents ∷ Either Artist Mbid → Maybe Autocorrect → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getPastEvents a autocorrect page limit apiKey = callAPI XML $
  target a ++
  [ (#) (Method "artist.getPastEvents")
  , (#) autocorrect
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get a podcast of free mp3s based on an artist.
--
-- More: <http://www.last.fm/api/show/artist.getPodcast>
getPodcast ∷ Either Artist Mbid → Maybe Autocorrect → APIKey → Lastfm Response
getPodcast a autocorrect apiKey = callAPI XML $
  target a ++
  [ (#) (Method "artist.getPodcast")
  , (#) autocorrect
  , (#) apiKey
  ]

-- | Get shouts for this artist. Also available as an rss feed.
--
-- More: <http://www.last.fm/api/show/artist.getShouts>
getShouts ∷ Either Artist Mbid → Maybe Autocorrect → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getShouts a autocorrect page limit apiKey = callAPI XML $
  target a ++
  [ (#) (Method "artist.getShouts")
  , (#) autocorrect
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get all the artists similar to this artist.
--
-- More: <http://www.last.fm/api/show/artist.getSimilar>
getSimilar ∷ Either Artist Mbid → Maybe Autocorrect → Maybe Limit → APIKey → Lastfm Response
getSimilar a autocorrect limit apiKey = callAPI XML $
  target a ++
  [ (#) (Method "artist.getSimilar")
  , (#) autocorrect
  , (#) limit
  , (#) apiKey
  ]

-- | Get the tags applied by an individual user to an artist on Last.fm. If accessed as an authenticated service /and/ you don't supply a user parameter then this service will return tags for the authenticated user.
--
-- More: <http://www.last.fm/api/show/artist.getTags>
getTags ∷ Either Artist Mbid → Maybe Autocorrect → Either User (SessionKey, Secret) → APIKey → Lastfm Response
getTags a autocorrect b apiKey = case b of
  Left user → callAPI XML $ target a ++ [(#) user] ++ args
  Right (sessionKey, secret) → callAPIsigned XML secret $ target a ++ [(#) sessionKey] ++ args
  where args =
          [ (#) (Method "artist.getTags")
          , (#) autocorrect
          , (#) apiKey
          ]

-- | Get the top albums for an artist on Last.fm, ordered by popularity.
--
-- More: <http://www.last.fm/api/show/artist.getTopAlbums>
getTopAlbums ∷ Either Artist Mbid → Maybe Autocorrect → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getTopAlbums a autocorrect page limit apiKey = callAPI XML $
  target a ++
  [ (#) (Method "artist.getTopAlbums")
  , (#) autocorrect
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get the top fans for an artist on Last.fm, based on listening data.
--
-- More: <http://www.last.fm/api/show/artist.getTopFans>
getTopFans ∷ Either Artist Mbid → Maybe Autocorrect → APIKey → Lastfm Response
getTopFans a autocorrect apiKey = callAPI XML $
  target a ++
  [ (#) (Method "artist.getTopFans")
  , (#) autocorrect
  , (#) apiKey
  ]

-- | Get the top tags for an artist on Last.fm, ordered by popularity.
--
-- More: <http://www.last.fm/api/show/artist.getTopTags>
getTopTags ∷ Either Artist Mbid → Maybe Autocorrect → APIKey → Lastfm Response
getTopTags a autocorrect apiKey = callAPI XML $
  target a ++
  [ (#) (Method "artist.getTopTags")
  , (#) autocorrect
  , (#) apiKey
  ]

-- | Get the top tracks by an artist on Last.fm, ordered by popularity.
--
-- More: <http://www.last.fm/api/show/artist.getTopTracks>
getTopTracks ∷ Either Artist Mbid → Maybe Autocorrect → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getTopTracks a autocorrect page limit apiKey = callAPI XML $
  target a ++
  [ (#) (Method "artist.getTopTracks")
  , (#) autocorrect
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Remove a user's tag from an artist.
--
-- More: <http://www.last.fm/api/show/artist.removeTag>
removeTag ∷ Artist → Tag → APIKey → SessionKey → Secret → Lastfm Response
removeTag artist tag apiKey sessionKey secret = callAPIsigned XML secret
  [ (#) (Method "artist.removeTag")
  , (#) artist
  , (#) tag
  , (#) apiKey
  , (#) sessionKey
  ]

-- | Search for an artist by name. Returns artist matches sorted by relevance.
--
-- More: <http://www.last.fm/api/show/artist.search>
search ∷ Artist → Maybe Page → Maybe Limit → APIKey → Lastfm Response
search artist page limit apiKey = callAPI XML
  [ (#) (Method "artist.search")
  , (#) artist
  , (#) apiKey
  , (#) page
  , (#) limit
  ]

-- | Share an artist with Last.fm users or other friends.
--
-- More: <http://www.last.fm/api/show/artist.share>
share ∷ Artist → Recipient → Maybe Message → Maybe Public → APIKey → SessionKey → Secret → Lastfm Response
share artist recipient message public apiKey sessionKey secret = callAPIsigned XML secret
  [ (#) (Method "artist.share")
  , (#) artist
  , (#) recipient
  , (#) apiKey
  , (#) sessionKey
  , (#) public
  , (#) message
  ]

-- | Shout in this artist's shoutbox.
--
-- More: <http://www.last.fm/api/show/artist.shout>
shout ∷ Artist → Message → APIKey → SessionKey → Secret → Lastfm Response
shout artist message apiKey sessionKey secret = callAPIsigned XML secret
  [ (#) (Method "artist.shout")
  , (#) artist
  , (#) message
  , (#) apiKey
  , (#) sessionKey
  ]

target ∷ Either Artist Mbid → [(String, String)]
target = return . (#) ||| return . (#)