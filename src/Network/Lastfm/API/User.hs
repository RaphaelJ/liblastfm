-- | User API module
{-# OPTIONS_HADDOCK prune #-}
module Network.Lastfm.API.User
  ( getArtistTracks, getBannedTracks, getEvents, getFriends, getInfo, getLovedTracks
  , getNeighbours, getNewReleases, getPastEvents, getPersonalTags, getPlaylists, getRecentStations
  , getRecentTracks, getRecommendedArtists, getRecommendedEvents, getShouts, getTopAlbums
  , getTopArtists, getTopTags, getTopTracks, getWeeklyAlbumChart, getWeeklyArtistChart
  , getWeeklyChartList, getWeeklyTrackChart, shout
  ) where

import Network.Lastfm

-- | Get a list of tracks by a given artist scrobbled by this user, including scrobble time. Can be limited to specific timeranges, defaults to all time.
--
-- More: <http://www.last.fm/api/show/user.getArtistTracks>
getArtistTracks ∷ User → Artist → Maybe StartTimestamp → Maybe EndTimestamp → Maybe Page → APIKey → Lastfm Response
getArtistTracks user artist startTimestamp endTimestamp page apiKey = callAPI XML
  [ (#) (Method "user.getArtistTracks")
  , (#) user
  , (#) artist
  , (#) startTimestamp
  , (#) page
  , (#) endTimestamp
  , (#) apiKey
  ]

-- | Returns the tracks banned by the user.
--
-- More: <http://www.last.fm/api/show/user.getBannedTracks>
getBannedTracks ∷ User → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getBannedTracks user page limit apiKey = callAPI XML
  [ (#) (Method "user.getBannedTracks")
  , (#) user
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get a list of upcoming events that this user is attending.
--
-- Mpre: <http://www.last.fm/api/show/user.getEvents>
getEvents ∷ User → Maybe Page → Maybe Limit → Maybe FestivalsOnly → APIKey → Lastfm Response
getEvents user page limit festivalsOnly apiKey = callAPI XML
  [ (#) (Method "user.getEvents")
  , (#) user
  , (#) page
  , (#) limit
  , (#) festivalsOnly
  , (#) apiKey
  ]

-- | Get a list of the user's friends on Last.fm.
--
-- More: <http://www.last.fm/api/show/user.getFriends>
getFriends ∷ User → Maybe RecentTracks → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getFriends user recentTracks page limit apiKey = callAPI XML
  [ (#) (Method "user.getFriends")
  , (#) user
  , (#) recentTracks
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get information about a user profile.
--
-- More: <http://www.last.fm/api/show/user.getInfo>
getInfo ∷ Maybe User → APIKey → Lastfm Response
getInfo user apiKey = callAPI XML
  [ (#) (Method "user.getInfo")
  , (#) user
  , (#) apiKey
  ]

-- | Get tracks loved by a user.
--
-- More: <http://www.last.fm/api/show/user.getLovedTracks>
getLovedTracks ∷ User → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getLovedTracks user page limit apiKey = callAPI XML
  [ (#) (Method "user.getLovedTracks")
  , (#) user
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get a list of a user's neighbours on Last.fm.
--
-- More: <http://www.last.fm/api/show/user.getNeighbours>
getNeighbours ∷ User → Maybe Limit → APIKey → Lastfm Response
getNeighbours user limit apiKey = callAPI XML
  [ (#) (Method "user.getNeighbours")
  , (#) user
  , (#) limit
  , (#) apiKey
  ]

-- | Gets a list of forthcoming releases based on a user's musical taste.
--
-- More: <http://www.last.fm/api/show/user.getNewReleases>
getNewReleases ∷ User → Maybe UseRecs → APIKey → Lastfm Response
getNewReleases user useRecs apiKey = callAPI XML
  [ (#) (Method "user.getNewReleases")
  , (#) user
  , (#) useRecs
  , (#) apiKey
  ]

-- | Get a paginated list of all events a user has attended in the past.
--
-- More: <http://www.last.fm/api/show/user.getPastEvents>
getPastEvents ∷ User → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getPastEvents user page limit apiKey = callAPI XML
  [ (#) (Method "user.getPastEvents")
  , (#) user
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get the user's personal tags.
--
-- More: <http://www.last.fm/api/show/user.getPersonalTags>
getPersonalTags ∷ User
                → Tag
                → TaggingType
                → Maybe Page
                → Maybe Limit
                → APIKey
                → Lastfm Response
getPersonalTags user tag taggingType page limit apiKey = callAPI XML
  [ (#) (Method "user.getPersonalTags")
  , (#) user
  , (#) tag
  , (#) taggingType
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get a list of a user's playlists on Last.fm.
--
-- More: <http://www.last.fm/api/show/user.getPlaylists>
getPlaylists ∷ User → APIKey → Lastfm Response
getPlaylists user apiKey = callAPI XML
  [ (#) (Method "user.getPlaylists")
  , (#) user
  , (#) apiKey
  ]

-- | Get a list of the recent Stations listened to by this user.
--
-- More: <http://www.last.fm/api/show/user.getRecentStations>
getRecentStations ∷ User → Maybe Page → Maybe Limit → APIKey → SessionKey → Secret → Lastfm Response
getRecentStations user page limit apiKey sessionKey secret = callAPIsigned XML secret
  [ (#) (Method "user.getRecentStations")
  , (#) user
  , (#) page
  , (#) limit
  , (#) apiKey
  , (#) sessionKey
  ]

-- | Get a list of the recent tracks listened to by this user. Also includes the currently playing track with the nowplaying="true" attribute if the user is currently listening.
--
-- More: <http://www.last.fm/api/show/user.getRecentTracks>
getRecentTracks ∷ User → Maybe Page → Maybe Limit → Maybe From → Maybe To → APIKey → Lastfm Response
getRecentTracks user page limit from to apiKey = callAPI XML
  [ (#) (Method "user.getRecentTracks")
  , (#) user
  , (#) page
  , (#) limit
  , (#) from
  , (#) to
  , (#) apiKey
  ]

-- | Get Last.fm artist recommendations for a user.
--
-- Mpre: <http://www.last.fm/api/show/user.getRecommendedArtists>
getRecommendedArtists ∷ Maybe Page → Maybe Limit → APIKey → SessionKey → Secret → Lastfm Response
getRecommendedArtists page limit apiKey sessionKey secret = callAPIsigned XML secret
  [ (#) (Method "user.getRecommendedArtists")
  , (#) page
  , (#) limit
  , (#) apiKey
  , (#) sessionKey
  ]

-- | Get a paginated list of all events recommended to a user by Last.fm, based on their listening profile.
--
-- More: <http://www.last.fm/api/show/user.getRecommendedEvents>
getRecommendedEvents ∷ Maybe Page → Maybe Limit → APIKey → SessionKey → Secret → Lastfm Response
getRecommendedEvents page limit apiKey sessionKey secret = callAPIsigned XML secret
  [ (#) (Method "user.getRecommendedEvents")
  , (#) page
  , (#) limit
  , (#) apiKey
  , (#) sessionKey
  ]

-- | Get shouts for this user. Also available as an rss feed.
--
-- More: <http://www.last.fm/api/show/user.getShouts>
getShouts ∷ User → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getShouts user page limit apiKey = callAPI XML
  [ (#) (Method "user.getShouts")
  , (#) user
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get the top albums listened to by a user. You can stipulate a time period. Sends the overall chart by default.
--
-- More: <http://www.last.fm/api/show/user.getTopAlbums>
getTopAlbums ∷ User → Maybe Period → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getTopAlbums user period page limit apiKey = callAPI XML
  [ (#) (Method "user.getTopAlbums")
  , (#) user
  , (#) period
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get the top artists listened to by a user. You can stipulate a time period. Sends the overall chart by default.
--
-- More: <http://www.last.fm/api/show/user.getTopArtists>
getTopArtists ∷ User → Maybe Period → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getTopArtists user period page limit apiKey = callAPI XML
  [ (#) (Method "user.getTopArtists")
  , (#) user
  , (#) period
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get the top tags used by this user.
--
-- More: <http://www.last.fm/api/show/user.getTopTags>
getTopTags ∷ User → Maybe Limit → APIKey → Lastfm Response
getTopTags user limit apiKey = callAPI XML
  [ (#) (Method "user.getTopTags")
  , (#) user
  , (#) limit
  , (#) apiKey
  ]

-- | Get the top tracks listened to by a user. You can stipulate a time period. Sends the overall chart by default.
--
-- More: <http://www.last.fm/api/show/user.getTopTracks>
getTopTracks ∷ User → Maybe Period → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getTopTracks user period page limit apiKey = callAPI XML
  [ (#) (Method "user.getTopTracks")
  , (#) user
  , (#) period
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get an album chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent album chart for this user.
--
-- More: <http://www.last.fm/api/show/user.getWeeklyAlbumChart>
getWeeklyAlbumChart ∷ User → Maybe From → Maybe To → APIKey → Lastfm Response
getWeeklyAlbumChart user from to apiKey = callAPI XML
  [ (#) (Method "user.getWeeklyAlbumChart")
  , (#) user
  , (#) from
  , (#) to
  , (#) apiKey
  ]

-- | Get an artist chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent artist chart for this user.
--
-- More: <http://www.last.fm/api/show/user.getWeeklyArtistChart>
getWeeklyArtistChart ∷ User → Maybe From → Maybe To → APIKey → Lastfm Response
getWeeklyArtistChart user from to apiKey = callAPI XML
  [ (#) (Method "user.getWeeklyArtistChart")
  , (#) user
  , (#) from
  , (#) to
  , (#) apiKey
  ]

-- | Get a list of available charts for this user, expressed as date ranges which can be sent to the chart services.
--
-- More: <http://www.last.fm/api/show/user.getWeeklyChartList>
getWeeklyChartList ∷ User → APIKey → Lastfm Response
getWeeklyChartList user apiKey = callAPI XML
  [ (#) (Method "user.getWeeklyChartList")
  , (#) user
  , (#) apiKey
  ]

-- | Get a track chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent track chart for this user.
--
-- More: <http://www.last.fm/api/show/user.getWeeklyTrackChart>
getWeeklyTrackChart ∷ User → Maybe From → Maybe To → APIKey → Lastfm Response
getWeeklyTrackChart user from to apiKey = callAPI XML
  [ (#) (Method "user.getWeeklyTrackChart")
  , (#) user
  , (#) from
  , (#) to
  , (#) apiKey
  ]

-- | Shout on this user's shoutbox.
--
-- More: <http://www.last.fm/api/show/user.shout>
shout ∷ User → Message → APIKey → SessionKey → Secret → Lastfm Response
shout user message apiKey sessionKey secret = callAPIsigned XML secret
  [ (#) (Method "user.shout")
  , (#) user
  , (#) message
  , (#) apiKey
  , (#) sessionKey
  ]