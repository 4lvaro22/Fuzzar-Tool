import { Parser } from 'json2csv';

export const downloadResource = (res, fileName, data) => {
  const json2csv = new Parser();
  const csv = json2csv.parse(data);
  res.header('Content-Type', 'text/csv');
  res.attachment(fileName);
  return res.send(csv);
}