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

function timer(millis) {
  var c = Math.ceil(millis / 1000);
  var m = Math.floor(c / 60);
  var s = c % 60;
  if (m == 0) return s;
  else return "" + m + ":" + s;
}

function readData(id, el) {
  var value = $.trim($(('#' + id), el).html());
  return value && JSON.parse(value);
}

module.exports = {
  post: post,
  cx: cx,
  timer: timer,
  readData: readData
};
