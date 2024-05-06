var express = require('express');
var router = express.Router();
const analysisController = require('../controllers/analysis');
const profileController = require('../controllers/profiles');

router.get("/", analysisController.getAnalysis);
router.get("/:page", analysisController.getAnalysis);
router.get("/delete/:id", analysisController.deleteAnalysis);
router.get("/csv/download", analysisController.downloadCSV);

router.get("/profile/execute", profileController.getProfiles);
router.post("/profile/execute/:name", profileController.executionProfile);

module.exports = router;
