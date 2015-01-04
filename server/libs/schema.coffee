db = require('./db')
schema = require('../config/db/schema.json')

for collection of schema.indexes
  for specs in schema.indexes[collection]
    db.ensureIndex collection, specs[0], specs[1], ->
      # nothing