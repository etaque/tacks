print(db.time_trial_runs.update({
  finishTime: {$exists: true}
}, {
  $inc: { finishTime: NumberLong("-20000") }
}, { multi: true }));


print(db.time_trial_runs.update({
  tally: {$size: 3}
}, {$inc: {
  "tally.0": NumberLong("-20000"),
  "tally.1": NumberLong("-20000"),
  "tally.2": NumberLong("-20000")
}}, { multi: true }));

print(db.time_trial_runs.update({
  tally: {$size: 5}
}, {$inc: {
  "tally.0": NumberLong("-20000"),
  "tally.1": NumberLong("-20000"),
  "tally.2": NumberLong("-20000"),
  "tally.3": NumberLong("-20000"),
  "tally.4": NumberLong("-20000")
}}, { multi: true }));

print(db.time_trial_runs.update({
  tally: {$size: 7}
}, {$inc: {
  "tally.0": NumberLong("-20000"),
  "tally.1": NumberLong("-20000"),
  "tally.2": NumberLong("-20000"),
  "tally.3": NumberLong("-20000"),
  "tally.4": NumberLong("-20000"),
  "tally.5": NumberLong("-20000"),
  "tally.6": NumberLong("-20000")
}}, { multi: true }));

