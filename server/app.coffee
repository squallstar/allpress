# Hack to load require modules without relative paths
process.env.NODE_PATH = __dirname
require('module').Module._initPaths()

compression = require('compression')
express = require("express")
path = require("path")
favicon = require("serve-favicon")
logger = require("morgan")
cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
busboy = require('connect-busboy');
config = require('./libs/config')
dblogger = require('./libs/dblogger')
helpers = require('./libs/helpers')
app = express()
FB = require('fb')
AWS = require('aws-sdk')
mailer = require('express-mailer')
stripe = require('stripe')(config.stripe.secret_key)

# disable socket pooling
require('http').globalAgent.maxSockets = Infinity

# application local vars
app.locals.environment = if process.env.NODE_ENV? then process.env.NODE_ENV.toLowerCase() else 'development'
app.locals.build = helpers.currentTimestamp()
app.locals.base_url = config.host

# crashes report
if app.locals.environment in ['staging', 'production']
  require('crashreporter').configure
    outDir: './logs'
    maxCrashFile: 100
    mailEnabled: true
    mailTransportName: 'SMTP'
    mailSubject: 'Crash Report'
    mailFrom: 'CrashReporter <hello@example.org>'
    mailTo: 'your-email-address@example.org'
    mailTransportConfig:
      host: config.internal_mailer.host
      auth:
        user: config.internal_mailer.email
        pass: config.internal_mailer.password

# setup plugins keys
mailer.extend app,
  from: config.mailer.from
  host: config.mailer.host
  secureConnection: true
  port: 465
  transportMethod: 'SMTP'
  auth:
    user: config.mailer.email
    pass: config.mailer.password

AWS.config.update
  accessKeyId: config.amazon.consumer_key
  secretAccessKey: config.amazon.consumer_secret
  region: config.amazon.region

FB.options
  appId: config.facebook.app_id
  appSecret: config.facebook.app_secret

# ensure we have up-to-date indexes on db
require('./libs/schema')

# view engine setup
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
if app.locals.environment isnt 'development' then app.set "view cache", true

# we used to run under a proxy on production
if config.proxy then app.enable "trust proxy"

# admin paths basic authentication
httpAuth = require('http-auth')
basic = httpAuth.basic {realm: 'Example'}, (username, password, callback) ->
  callback username is config.admin.username and password is config.admin.password
app.use "/admin", httpAuth.connect(basic)

# Middle-wares setup
app.use compression()
app.use dblogger
app.use favicon(__dirname + '/public/favicon.ico')
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: false
app.use cookieParser()
app.use busboy()
app.use express.static(path.join(__dirname, "public"),
  maxage: '1h'
)

# Website routes
app.use "/", require("./routes/website/index")

# Email routes
app.use "/email", require("./routes/email")

# API routes
app.use "/v1", require("./routes/api/v1/auth")

# Admin routes
app.use "/admin", require("./routes/admin/index")

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err
  return

# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err
    return

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  status = err.status or 500
  res.status status
  res.send error:
    status: status
    message: err.message
  return

module.exports = app