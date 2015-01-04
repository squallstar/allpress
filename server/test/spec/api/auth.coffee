superagent = require('superagent')
expect = require('expect.js')

describe 'Authentication', ->

  it 'Returns 400 when logging in without params', (done) ->
    superagent.post("#{process.host}v1/login").end (e, res) ->
      expect(res.status).to.be 400
      done()