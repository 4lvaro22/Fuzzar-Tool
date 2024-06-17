var express = require('express');
var router = express.Router();
const analysisController = require('../controllers/analysis');
const profileController = require('../controllers/profiles');

router.get("/", (req, res) => {
  res.render("index");
})

router.get("/analysis", analysisController.getAnalysis);
router.get("/analysis/page/:page", analysisController.getAnalysis);
router.get("/analysis/delete/:id", analysisController.deleteAnalysis);

router.get("/profile", profileController.getProfiles);
router.get("/profile/page/:page", profileController.getProfiles);
router.post("/profile/execute/:name", profileController.executionProfile);
router.get("/profile/new", profileController.newProfile);
router.get("/profile/new/:defName", profileController.newProfile);
router.post("/profile/save", profileController.saveProfile);
router.get("/profile/delete/:name", profileController.deleteProfile);

module.exports = router;
