"use strict";

var $ = require('jquery');
var React = require('react');
// var LiveCenter = React.createFactory(require('./liveCenter.jsx'));
var notifications = require('./notifications');
var fileUpload = require('./fileUpload');
var mountElm = require('./mountElm');

window.$ = window.jQuery = $;
require('../node_modules/bootstrap-sass/assets/javascripts/bootstrap/transition');
require('../node_modules/bootstrap-sass/assets/javascripts/bootstrap/collapse');

$(function() {

  notifications();

  $(".upload-avatar").each(function() {
    fileUpload(this, "avatar");
  });

  $("#liveCenter").each(function() {
    // React.render(LiveCenter(), this);
    // mountElm.mountLiveCenter(this);
  });

  $(".elm-game").each(function() {
    mountElm.mountGame();
  });

  $("#chat").each(function() {
    mountElm.mountChat(this);
  });

});
