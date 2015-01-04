express = require("express")
router = express.Router()

# --------------------------------------------------------------------------

router.get "/", (req, res) ->
  res.render 'admin/index', title: 'Admin'

# --------------------------------------------------------------------------

module.exports = router