const fs = require('fs').promises;
const controller = {};
const path = require('path');
const filePathTestDone = path.resolve(__dirname, "../data.json");

controller.getAnalysis = async function (req, res, next) {
  var databaseData = []
  try {
    var data = await fs.readFile(filePathTestDone, { encoding: 'utf-8' });
    databaseData = JSON.parse(data);

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
    res.redirect("/analysis");
  } else {
    actualPage = req.params.page;
    initialData = 10 * (req.params.page - 1);
    lastData = 10 * req.params.page;
  }

  res.render("tests.ejs", { totalAnalysis: databaseData, analysis: databaseData.slice(initialData, lastData), actualPage: actualPage, initialData: initialData, lastData: lastData, profiles: undefined  });

};

controller.deleteAnalysis = async function (req, res, next) {
  try {
    const data = await fs.readFile(filePathTestDone, { encoding: 'utf-8' });
    const databaseData = JSON.parse(data);

    var removedObject = databaseData.filter((obj) => obj.id === req.params.id);
    fs.rm('results/result-' + removedObject[0]["initial_time"], {recursive: true, force: true });
    var removedArray = databaseData.filter((obj) => obj.id !== req.params.id);
    removedArray = JSON.stringify(removedArray)

    try {
      fs.writeFile(filePathTestDone, removedArray, 'utf-8')
    } catch (err) {
      console.error(err);
    }

    res.redirect("/analysis");
  } catch (error) {
    res.send("Se ha producido un error. " + error);
  }
};

module.exports = controller;