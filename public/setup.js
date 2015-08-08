"use strict";

var $ = require('jquery');

var notifications = require('./notifications');
var mountElm = require('./mountElm');


$(function() {

  notifications();

  $(".elm-game").each(function() {
    mountElm();
  });

});
