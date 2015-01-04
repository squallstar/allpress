mcapi = require('../node_modules/mailchimp-api/mailchimp')
config = require('./config')

module.exports = new mcapi.Mailchimp config.mailchimp.api_key