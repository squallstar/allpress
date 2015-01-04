config = require('./config')
moment = require('moment')

module.exports =
  sendPlainEmail: (mailer, data, callback) ->
    mailer.send 'email/plain-text', data, (err) ->
      if typeof callback is 'function' then callback err

  # Sends a welcome email to the user
  # user: {to: (email string), full_name: (string)}
  sendWelcomeEmail: (mailer, user, callback) ->
    user.base_url = config.host
    user.subject = 'Welcome'
    mailer.send 'email/welcome', user, (err) ->
      console.log if err then err else "Welcome email sent to #{user.to}"
      if typeof callback is 'function' then callback err