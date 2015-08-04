"use strict";

var $ = require('jquery');

var notifications = require('./notifications');
var fileUpload = require('./fileUpload');
var mountElm = require('./mountElm');


$(function() {

  notifications();

  $(".upload-avatar").each(function() {
    fileUpload(this, "avatar");
  });

  $(".elm-game").each(function() {
    mountElm();
  });

});
