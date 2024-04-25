var express = require('express');
var router = express.Router();
const analysisController = require('../controllers/analysis');

router.get("/", analysisController.getAnalysis);
router.get("/:page", analysisController.getAnalysis);
router.get("/delete/:id", analysisController.deleteAnalysis);
router.get("/csv/download", analysisController.downloadCSV);

module.exports = router;
