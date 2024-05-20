const fs = require('fs').promises;
const controller = {};
const path = require('path');
const { exec, execSync, spawn } = require("child_process");
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

  res.render("execute.ejs", { totalProfiles: profilesData, profiles: profilesData.slice(initialData, lastData), actualPage: actualPage, initialData: initialData, lastData: lastData, analysis: undefined });
};

controller.executionProfile = async function (req, res, next) {
  try {
    var exitByTimeOut = 0;
    const TIMEOUT = 3600000;

    const profiles = await fs.readFile(filePathProfiles, { encoding: 'utf-8' });
    const profilesData = JSON.parse(profiles);

    const executeProfile = profilesData.find(element => element.name === req.params.name);
    
    const child = spawn("bash", ["webapp.sh",
                                  `${executeProfile.data_source}`,
                                  `${executeProfile.path_simulator}`,
                                  `${executeProfile.config_compilator}`,
                                  `${executeProfile.config_fuzzing}`,
                                  `${executeProfile.errors_directory}`,
                                  `${executeProfile.description}`,
                                  `${executeProfile.name}`]);

    const timeoutId = setTimeout(() => {
      child.kill('SIGKILL');
      exitByTimeOut = 1;
    }, TIMEOUT);

    child.on('error', (error) => {
      clearTimeout(timeoutId);
    });
    
    child.on('close', (code, signal) => {
      clearTimeout(timeoutId);

      const dataModifier = spawn("python3", ['script/data_modifier.py', `${executeProfile.data_source}`, `${executeProfile.path_simulator}`, `${executeProfile.config_compilator}`, `${executeProfile.config_fuzzing}`, `${executeProfile.errors_directory}`, `${executeProfile.description}`, `${executeProfile.name}`, (code === 0 || timeoutId === 1) ? 'success' : 'error'])
      
      res.redirect("/analysis");
    });
  } catch (err) {
    console.error(err);
    // Handle error appropriately (e.g., send error response to client)
  }
};

controller.newProfile = async function (req, res, next) {
  res.render("create.ejs", { analysis: undefined });
};

controller.saveProfile = async function (req, res, next) {
  try {
    var profiles = await fs.readFile(filePathProfiles, { encoding: 'utf-8' });
    profilesData = JSON.parse(profiles);

    let name = req.body.name;
    existProfile = profilesData.filter(element => element.name.search(RegExp("^" + name + "(?:\(\d+\))*$")) !== -1)

    if (existProfile.length !== 0) {
      name += " (" + existProfile.length + ")"
    }

    let dirErrs = req.body.dirErrs;
    let confComp = req.body.confComp;
    let confFuzzer = req.body.confFuzz;
    let pathSim = req.body.pathSim;
    let data = req.body.data;
    let description = req.body.description;

    let newProfile = {
      "name": name,
      "errors_directory": dirErrs,
      "config_compilator": confComp,
      "config_fuzzer": confFuzzer,
      "path_simulator": pathSim,
      "data_source": data,
      "description": description
    };

    profilesData.push(newProfile);
    await fs.writeFile(filePathProfiles, JSON.stringify(profilesData, null, 2), { encoding: 'utf-8' });

    res.redirect("/profile")

  } catch (error) {
    res.send("Se ha producido un error " + error);
  }

};

controller.deleteProfile = async function (req, res, next) {
  try {
    var profiles = await fs.readFile(filePathProfiles, { encoding: 'utf-8' });
    profilesData = JSON.parse(profiles);

    var removedArray = profilesData.filter((obj) => obj.name !== req.params.name);
    removedArray = JSON.stringify(removedArray)

    fs.writeFile(filePathProfiles, removedArray, 'utf-8')

    res.redirect("/profile");
  } catch (error) {
    res.send("Se ha producido un error. " + error);
  }
};

module.exports = controller;