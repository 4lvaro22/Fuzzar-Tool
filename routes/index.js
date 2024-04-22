var express = require('express');
var router = express.Router();
const analysisController = require('../controllers/analysis');

router.get("/", analysisController.getAnalysis);

module.exports = router;
