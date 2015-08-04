var $ = require('jquery');

function readData(id, el) {
  var value = $.trim($(('#' + id), el).html());
  return value && JSON.parse(value);
}

module.exports = {
  readData: readData
};
