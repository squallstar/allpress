mongo = require('mongoskin')
config = require('./config')

module.exports = mongo.db "mongodb://#{config.database.path}", {native_parser:true}