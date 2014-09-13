var $     = require('jquery');
var _     = require('lodash');

function post(route, data) {
  return $.ajax(_.merge(route, {
    data: JSON.stringify(data || {}),
    dataType: "json",
    contentType: "application/json"
  }));
}

module.exports = {
  post: post
};