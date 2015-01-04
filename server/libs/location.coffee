geoip = require('geoip-lite')

module.exports =
  locateIp: (req) ->
    ip = req.headers['x-forwarded-for'] or req.connection.remoteAddress
    real_ip = ip

    if not ip or ip is '127.0.0.1'
      # Default ip to London
      ip = "37.157.39.238"
      real_ip = req.connection.remoteAddress

    if data = geoip.lookup ip
      {
        ip: real_ip
        lat: data.ll[0]
        lon: data.ll[1]
        country: data.country
        region: data.region
        city: data.city
      }
    else
      false