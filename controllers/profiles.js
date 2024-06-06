const fs = require('fs').promises;
const controller = {};
const path = require('path');
const { exec, execSync, spawn, spawnSync } = require("child_process");
const filePathProfiles = path.resolve(__dirname, "../database/profiles.json");
const filePathDefaultProfiles = path.resolve(__dirname, "../database/default_profiles.json");

controller.getProfiles = async function (req, res, next) {
  try {
    var profilesData = []

    var profiles = await fs.readFile(filePathProfiles, { encoding: 'utf-8' });
    profilesData = JSON.parse(profiles);

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
  } catch (err) {
    if (err.message.includes('parse')) {
      res.status(400).send('Error: Invalid analysis data format in file');
    } else {
      const err = new Error();
      err.message = 'Internal Server Error';
      err.status = 500
      next(err); // Pass the custom error object to the global handler
    }
  }
};

controller.executionProfile = async function (req, res, next) {
  try{
    var exitError = 0;
    
    const profiles = await fs.readFile(filePathProfiles, { encoding: 'utf-8' });
    const profilesData = JSON.parse(profiles);
    
    const executeProfile = profilesData.find(element => element.name === req.params.name);
    const TIMEOUT = executeProfile.time;
    
    const child = spawnSync("/bin/bash", ["webapp.sh",
      `${executeProfile.data_source}`,
      `${executeProfile.path_simulator}`,
      `${executeProfile.config_compilator}`,
      `${executeProfile.config_fuzzing}`,
      `${executeProfile.errors_directory}`,
      `${executeProfile.description}`,
      `${executeProfile.name}`],
      {
        encoding: 'utf-8',
        timeout: TIMEOUT
      });

    if (child.stderr) {
      exitError = 1;
    }

    const dataModifier = spawnSync("python3", ['script/data_modifier.py', 
      `${executeProfile.data_source}`, 
      `${executeProfile.path_simulator}`, 
      `${executeProfile.config_compilator}`, 
      `${executeProfile.config_fuzzing}`, 
      `${executeProfile.errors_directory}`, 
      `${executeProfile.description}`, 
      `${executeProfile.name}`, 
    (exitError === 0) ? 'Success' : 'Error']);

    res.redirect('/analysis');
  } catch (err) {
    if (err.message.includes('parse')) {
      res.status(400).send('Error: Invalid analysis data format in file');
    } else {
      const err = new Error();
      err.message = 'Internal Server Error';
      err.status = 500
      next(err); // Pass the custom error object to the global handler
    }
  }
};

controller.newProfile = async function (req, res, next) {
  try {
    var defaultsProfiles = await fs.readFile(filePathDefaultProfiles, { encoding: 'utf-8' });
    defaultProfilesData = JSON.parse(defaultsProfiles);

    var selectedProfile = undefined;


    if (req.params.defName !== undefined) {
      selectedProfile = defaultProfilesData.find(element => element.name === req.params.defName);

      if (selectedProfile === undefined) {
        err.message = 'Bad Request';
        err.status = 400
        next(err);
      }
    }

    res.render("create.ejs", { analysis: undefined, defaultsProfiles: defaultProfilesData, selectedProfile: selectedProfile });

  } catch (err) {
    if (err.message.includes('parse')) {
      res.status(400).send('Error: Invalid analysis data format in file');
    } else {
      const err = new Error();
      err.message = 'Internal Server Error';
      err.status = 500
      next(err); // Pass the custom error object to the global handler
    }
  }

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
    let time = req.body.time;

    let newProfile = {
      "name": name,
      "errors_directory": dirErrs,
      "config_compilator": confComp,
      "config_fuzzer": confFuzzer,
      "path_simulator": pathSim,
      "data_source": data,
      "description": description,
      "time": time
    };

    profilesData.push(newProfile);
    await fs.writeFile(filePathProfiles, JSON.stringify(profilesData, null, 2), { encoding: 'utf-8' });

    res.redirect("/profile")

  } catch (err) {
    if (err.message.includes('parse')) {
      res.status(400).send('Error: Invalid analysis data format in file');
    } else {
      const err = new Error();
      err.message = 'Internal Server Error';
      err.status = 500
      next(err); // Pass the custom error object to the global handler
    }
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
  } catch (err) {
    if (err.message.includes('parse')) {
      res.status(400).send('Error: Invalid analysis data format in file');
    } else {
      const err = new Error();
      err.message = 'Internal Server Error';
      err.status = 500
      next(err); // Pass the custom error object to the global handler
    }
  }
};

module.exports = controller;