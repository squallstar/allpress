users = require('models/users')

# req optional params: req.auth_required (bool), req.require_pro (bool)
# "next" callback arguments: (isLogged, isPro)
module.exports = (req, res, next) ->
  req.auth_token = req.param('auth_token') or req.cookies.auth_token

  unless req.auth_token
    if req.auth_required is false
      next false, false
    else
      res.redirect "/login?r=#{req.originalUrl}"
  else
    users.findByAuthToken req.auth_token, (user) ->
      if user
        if req.require_pro is true and user.is_pro isnt true
          if req.auth_required is false
            return next false, false
        else
          req.user = user
          res.locals.user = user
          return next true, user.is_pro

      if req.auth_required is false
        next false, false
      else
        res.redirect "/login?r=#{req.originalUrl}"