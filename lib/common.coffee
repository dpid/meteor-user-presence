UserPresences = new Meteor.Collection 'userPresences'

Meteor.methods
  updateUserPresence : (params={}) ->

    connectionId = if @.isSimulation then Meteor.connection._lastSessionId else @.connection.id

    if not connectionId then return

    update = state : params.state or "online"
    if params.data then update.data = params.data

    if Meteor.userId? and Meteor.userId()
      update.userId = Meteor.userId()

    UserPresences.update connectionId, $set: update
