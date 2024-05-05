const fs = require('fs').promises;
const controller = {};
const path = require('path');
const filePath = path.resolve(__dirname, "../data.json");
const json2csv = require('json-2-csv')

controller.getAnalysis = async function (req, res, next) {
  var databaseData = []
  try {
    var data = await fs.readFile(filePath, { encoding: 'utf-8' });
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
    res.redirect("/");
  } else {
    actualPage = req.params.page;
    initialData = 10 * (req.params.page - 1);
    lastData = 10 * req.params.page;
  }

  res.render("index", { totalAnalysis: databaseData, analysis: databaseData.slice(initialData, lastData), actualPage: actualPage, initialData: initialData, lastData: lastData });

};

controller.deleteAnalysis = async function (req, res, next) {
  try {
    const data = await fs.readFile(filePath, { encoding: 'utf-8' });
    const databaseData = JSON.parse(data);

    var removedObject = databaseData.filter((obj) => obj.id === req.params.id);
    fs.rm('results/result-' + removedObject[0]["initial_time"], {recursive: true, force: true });
    var removedArray = databaseData.filter((obj) => obj.id !== req.params.id);
    removedArray = JSON.stringify(removedArray)

    try {
      fs.writeFile(filePath, removedArray, 'utf-8')
    } catch (err) {
      console.error(err);
    }

    res.redirect("/");
  } catch (error) {
    res.send("Se ha producido un error. " + error);
  }
};

controller.downloadCSV = async function (req, res, next) {
  const data = await fs.readFile(filePath, { encoding: 'utf-8' });
  const databaseData = JSON.parse(data);
  const csv = await json2csv.json2csv(databaseData);

  res.setHeader("Content-disposition", "attachment; filename=data.csv");
  res.set("Content-Type", "text/csv");
  res.status(200).send(csv);
};

module.exports = controller;