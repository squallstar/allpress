request = require('request')
config = require('./config')
helpers = require('./helpers')

entrypoint = "https://api.foursquare.com"
version = 20140806

###

Example URL:
https://api.foursquare.com/v2/venues/search?ll=51.528400,-0.084481&radius=1000&client_id=1BG4UFZXEZELR5OZRIZ12LWYVTWC2UUNFII131LD5Q0PTSIP&client_secret=P5NAIHVA5BJWVTH04NZLA3K3DP5PSPN1BU0UOCAZH22P3O31&v=20140806&m=foursquare&intent=browse&query=forge%20co

###

venues =
  search: (options, callback) ->
    url = "#{entrypoint}/v2/venues/search"

    data =
      client_id: config.foursquare.app_id
      client_secret: config.foursquare.app_secret
      version: version
      m: 'foursquare'
      intent: 'browse'
      v: version

    if options.lat and options.lon
      data.ll = "#{options.lat.toString()},#{options.lon.toString()}"
      data.radius = 1000
    else
      data.intent = 'global'

    if options.query then data.query = options.query

    url += '?' + helpers.toParams(data)

    request url, (error, response, body) ->
      if error
        console.log 'error', error
        callback error
      else
        tmp = JSON.parse body
        venues = []

        if tmp.meta.code is 200 and tmp.response and tmp.response.venues
          for venue in tmp.response.venues
            venues.push
              id: venue.id
              name: venue.name
              address: venue.location.address
              city: venue.location.city
              state: venue.location.state
              country: venue.location.country
              categories: category.name for category in venue.categories
              checkins: venue.stats.checkinsCount
              location:
                lat: venue.location.lat
                lon: venue.location.lng

        callback error, venues

module.exports = venues