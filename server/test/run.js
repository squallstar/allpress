// Require hacks
process.env.NODE_PATH = __dirname + '/../'
require('module').Module._initPaths()

// Coffeescript
require('coffee-script/register')

// Env vars
process.env.NODE_ENV = 'tests';

// Config
var config = require('libs/config');
process.host = config.host;

// Specs
require('./spec/api/auth.coffee');

// Run the server
var app = require('../app');
app.set('port', config.port);
app.listen(config.port, config.interface);