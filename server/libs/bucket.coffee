config = require('./config')
AWS = require('aws-sdk')
module.exports = new AWS.S3 params: {Bucket: config.amazon.bucket}