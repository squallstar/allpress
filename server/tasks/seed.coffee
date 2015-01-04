casual = require('casual')
async = require('async')

users = require('../models/users')

if process.env.NODE_ENV is 'production'
  return console.log('Cannot run while in production')

console.log('Please wait while we generate the data...')

count = 0

async.whilst (->
  count < 2000
), ((callback) ->
  count++

  user =
    full_name: casual.full_name
    email: casual.email.toLowerCase()

  users.createNew user, null, ->
    do callback

), (err) ->
  console.log 'Dummy data created!!'