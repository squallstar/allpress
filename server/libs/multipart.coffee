module.exports =
  receive: (req, callback) ->
    fields = []

    req.busboy.on 'field', (key, value, keyTruncated, valueTruncated) ->
      fields[key] = value

    req.busboy.on 'file', (fieldname, file, filename, encoding, mimetype) ->
      if not filename or mimetype not in ['image/jpeg', 'image/png']
        return res.status(401).send error: 'Attached file must be an image'

      file.fileRead = []

      file.on 'data', (chunk) ->
        @fileRead.push chunk

      file.on 'error', (err) ->
        res.status(400).send error: 'Error receiving the file'

      file.on 'end', ->
        fields[fieldname] =
          name: filename
          content: Buffer.concat @fileRead
          encoding: encoding
          mimetype: mimetype
        delete @fileRead

    req.busboy.on 'finish', ->
      callback fields

    req.pipe req.busboy