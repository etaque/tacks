var $     = require('jquery');
var _     = require('lodash');

function post(route, data) {
  return $.ajax(_.merge(route, {
    data: JSON.stringify(data || {}),
    dataType: "json",
    contentType: "application/json"
  }));
}

function cx(classNames) {
  if (typeof classNames == 'object') {
    return Object.keys(classNames).map(function(className) {
      return classNames[className] ? className : '';
    }).join(' ');
  } else {
    return Array.prototype.join.call(arguments, ' ');
  }
}

module.exports = {
  post: post,
  cx: cx
};