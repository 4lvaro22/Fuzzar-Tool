const fs = require('fs').promises;
const controller = {};
const path = require('path');
const filePath = path.resolve(__dirname, "../data.json");

controller.getAnalysis = async function (req, res, next) {
  try {
    console.log("a");
    const data = await fs.readFile(filePath, { encoding: 'utf-8' });
    const databaseData = JSON.parse(data);

    res.render("index", { analysis: databaseData });
  } catch (error) {
    res.send("Se ha producido un error. " + error);
  }
};

module.exports = controller;