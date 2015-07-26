/**
 * @jsx React.DOM
 */

var React    = require('react');
var _        = require('lodash');
var moment   = require('moment');
var util     = require('../util');
var Messages = require('../messages');

var RaceCourse = require('./raceCourse');

var RaceCourseBoard = React.createClass({

  getRaceCourses: function(raceCourses) {
    return _.map(raceCourses, status => {
      return <RaceCourse status={status} key={status.raceCourse._id} />;
    });
  },

  render: function() {
    var raceCourses = this.getRaceCourses(this.props.raceCourses);

    return <div className="row">{ raceCourses }</div>;
  }

});

module.exports = RaceCourseBoard;
