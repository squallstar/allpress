express = require("express")
router = express.Router()

users = require("../models/users")

# --------------------------------------------------------------------------

router.get "/welcome", (req, res) ->
  res.render 'email/signup-welcome', full_name: 'John Doe'

# --------------------------------------------------------------------------

module.exports = router