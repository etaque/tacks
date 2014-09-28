
var React    = require('react');
var Bacon    = require('baconjs');
var $        = require('jquery');
var bjq      = require('bacon.jquery');
var Home     = require('./home');
var Api      = require('./api');

var user = Bacon.Model({});
var userName = user.lens("name");

$.ajax(Api.currentUser()).done(u => {
  user.set(u);

  React.renderComponent(<Home status={status} userName={userName}/>,
    document.getElementById("app"));
})

