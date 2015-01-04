express = require("express")
router = express.Router()
validator = require('validator')

router.get "/", (req, res) ->
  res.render 'website/home',
    className: 'landing'
    title: 'Welcome'

# --------------------------------------------------------------------------

module.exports = router