var React = require('react');

var TimeTrial = React.createClass({

  render: function() {
    return (
      <div className="time-trial"><a href={"/timeTrial/" + this.props.trial._id} target="_blank">TODO</a></div>
    );
  }

});

module.exports = TimeTrial;