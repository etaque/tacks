db.time_trial_runs.find().forEach(function(run) {
  print(db.time_trial_runs.update({_id: run._id}, {$set: {"time": run._id.getTimestamp() } }));
})