express = require("express")
router = express.Router()
users = require('models/users')

# --------------------------------------------------------------------------
# API: Log in, given email and password

router.post "/login", (req, res) ->
  data = {}
  for param in ['email', 'password']
    data[param] = req.param(param)
    unless data[param]
      return res.status(400).send {error: "#{param} is required"}

  users.findByEmailAndPassword data.email, data.password, (user) ->
    if user
      res.status(200).send user: user
    else
      res.status(401).send error: 'Email or password does not match'

# --------------------------------------------------------------------------

module.exports = router