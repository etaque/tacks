db.users.find().forEach(function(user) {
  print(db.users.update({_id: user._id}, {$set: {"vmgMagnet": NumberInt("10") } }));
})
