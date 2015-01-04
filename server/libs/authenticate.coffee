users = require('models/users')

module.exports = (req, res, next) ->
  req.auth_token = req.param('auth_token') or req.headers['auth-token'] or req.cookies.auth_token

  unless req.auth_token
    res.status(401).send error: 'auth_token not provided'
  else
    users.findByAuthToken req.auth_token, (user) ->
      if user
        if req.require_pro and user.is_pro isnt true
          res.status(401).send error: 'not authorized'
        else
          req.user = user
          next true
      else
        res.status(401).send error: 'auth_token not valid'