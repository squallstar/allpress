crypto = require('crypto')
config = require('./config')
moment = require('moment')
mongo = require('mongoskin')

module.exports =
  objectId: (hexStr) ->
    mongo.helper.toObjectID hexStr

  md5: (str) ->
    if typeof str isnt 'string' then str = ''
    crypto.createHash('md5').update(str).digest('hex')

  url: (uri) ->
    config.host + uri.replace(/^\//, '')

  currentTimestamp: ->
    Math.round(Date.now()/1000)

  timeAgo: (timestamp) ->
    moment(timestamp*1000).fromNow()

  urlForAmazonResource: (filename = '') ->
    "https://s3.#{config.amazon.region}.amazonaws.com/#{config.amazon.bucket}/#{filename}"

  keyForAmazonResource: (url = '') ->
    url.replace "https://s3.#{config.amazon.region}.amazonaws.com/#{config.amazon.bucket}", ''

  toParams: (data) ->
    params = []
    for key of data
      params.push key + '=' + encodeURIComponent(data[key])
    params.join('&')

  dbQueryForCenterInSphere: (latitude, longitude, radius) ->
    radius = parseInt radius, 10
    unless radius
      radius = 300

    '$geoWithin':
      '$centerSphere': [
        [parseFloat(longitude), parseFloat(latitude)], (radius / 6371)
      ]