const fs = require('fs').promises;
const controller = {};
const path = require('path');
const { exec } = require("child_process");
const filePathProfiles = path.resolve(__dirname, "../profiles.json");

controller.getProfiles = async function (req, res, next) {
  var profilesData = []
  try {
    var profiles = await fs.readFile(filePathProfiles, { encoding: 'utf-8' });
    profilesData = JSON.parse(profiles);
  } catch (error) {

  }

  if (req.params.page === undefined) {
    actualPage = 1;
    initialData = 0;
    lastData = 10;
  } else if (req.params.page === 1) {
    actualPage = 1;
    initialData = 0;
    lastData = 10;
    res.redirect("/");
  } else {
    actualPage = req.params.page;
    initialData = 10 * (req.params.page - 1);
    lastData = 10 * req.params.page;
  }

  res.render("execute.ejs", { totalProfiles: profilesData, profiles: profilesData.slice(initialData, lastData), actualPage: actualPage, initialData: initialData, lastData: lastData });
};

controller.executionProfile = async function (req, res, next) {
  exec(`sh hola.sh`, async (err, stdout, stderr) => {
    if (err) console.error(err)
    console.log(stdout);
    res.redirect("/");
  });
};

module.exports = controller;