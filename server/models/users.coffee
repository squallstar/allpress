crypto = require('crypto')
db = require('libs/db')
config = require('libs/config')
helpers = require('libs/helpers')
mailer = require('libs/mailer')

db.bind('users').bind
  encodePassword: (pwd) ->
    helpers.md5 "somethingrandom#{pwd}"

  generateAuthToken: (user) ->
    helpers.md5("#{user.email}.#{user.created_at}") + helpers.currentTimestamp()

  createNew: (data, mailerInstance, callback) ->
    data.created_at = helpers.currentTimestamp()
    data.auth_token = @generateAuthToken data
    data.optin_token = helpers.md5 "email#{data.created_at}#{data.email}"
    if data.password then data.password = @encodePassword data.password

    @insert data, (err, status) ->
      if status and mailerInstance
        mailer.sendWelcomeEmail mailerInstance, {to: data.email, full_name: data.full_name}
      callback err, status

  emailInUse: (email, callback) ->
    @count {email: email}, (err, count) ->
      callback count > 0

  findByAuthToken: (auth_token, callback) ->
    @findOne {auth_token: auth_token}, {_id: true, full_name: true, email: true}, (err, data) ->
      callback data

  findByEmailAndPassword: (email, password, callback) ->
    @findOne {email: email, password: @encodePassword(password)}, {password: false}, (err, data) ->
      callback data

module.exports = db.users