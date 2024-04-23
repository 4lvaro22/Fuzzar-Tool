const fs = require('fs').promises;
const controller = {};
const path = require('path');
const filePath = path.resolve(__dirname, "../data.json");

controller.getAnalysis = async function (req, res, next) {
  try {
    const data = await fs.readFile(filePath, { encoding: 'utf-8' });
    const databaseData = JSON.parse(data);

    if(req.params.page === undefined){
      actualPage = 1;
      initialData = 0;
      lastData = 10;
    }else if(req.params.page === 1){ 
      actualPage = 1;
      initialData = 0;
      lastData = 10;
      res.redirect("/");
    }else{
      initialData = 10 * (req.params.page - 1);
      lastData = 10 * req.params.page; 
    }


    res.render("index", { totalAnalysis: databaseData, analysis: databaseData.slice(initialData, lastData), actualPage: req.params.page});
  } catch (error) {
    res.send("Se ha producido un error. " + error);
  }
};

module.exports = controller;