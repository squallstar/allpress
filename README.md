# Allpress

This is my personal Node.js Express development setup for production composed as follows:

- Express 4
- Coffeescript
- Custom per-environment configuration files
- Multi-thread cluster support + workers autoreload
- Skeleton for a marketing website + APIs
- Requests logging to DB
- Crash reporter (email)
- Improved Node.js Require
- SSL support
- Async
- Tons of production-ready tweaks
- Gzip, Cookie parser, body parser, Busboy (multipart)
- GeoIP
- Mailer lib + helpers (HTML + plain)
- Styled and responsive email layout (based on Mailchimp) with design by @Mintsugar
- Mailchimp SDK + helpers
- Graphicmagick and GM node library
- Jade templates
- Stripe (payments)
- Auth token (param, cookie or header) authentication for APIs
- Basic auth for /admin dir
- Foursquare SDK + helpers
- DB with Mongoskin
- DB Indexes setup on load
- DB seeds support
- Casual
- HTML Skeleton with common meta tags
- Scss to CSS with basic skeleton structure and css reset
- Useful Scss placeholders (like %vertically-centered)
- Responsive support
- Google fonts and analytics support
- Coffee to JS for the frontend (with submodules support)
- Jquery and Jquery.sortable (on demand)
- JS minification on production
- Assets expiration on server restart
- Facebook SDK
- Amazon AWS SDK + S3 bucket helper
- Loads of helpers
- Tests with Mocha, Expect.js and Superagent
- Probably something else which I don't remember right now

## Run for development

    $ ./server/bin/www

You will also need to run grunt (on another tab) to compile and watch sass files:

    $ grunt

## Run for production with forever

    $ grunt precompile
    $ NODE_ENV=production forever start ./server/bin/www

## Run the tests

    $ npm test
