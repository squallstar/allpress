db = require('./db')
helpers = require('./helpers')

module.exports = (req, res, next) ->
  if req.originalUrl.indexOf('/v1') is 0
    db.collection('logs').insert {
      endpoint: req.originalUrl.replace /auth_token=[A-z0-9]+&?/, ''
      ip: req.headers['x-forwarded-for'] or req.connection.remoteAddress
      auth_token: req.param('auth_token') or req.headers['auth-token']
      ua: req.headers['user-agent']
      params: req.body
      method: req.method
      requested_at: helpers.currentTimestamp()
    }, {w: 0}

  next()