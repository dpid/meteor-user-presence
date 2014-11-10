connections = {}

idleDelay = 10000
tickDelay = 5000
onDisconnect = null

UserPresenceSettings = (params={}) ->
  idleDelay = params.idleDelay or idleDelay
  tickDelay = params.tickDelay or tickDelay
  onDisconnect = params.onDisconnect

expire = (id) ->
  onDisconnect?(UserPresences.findOne id)
  UserPresences.remove id
  delete connections[id]

idle = (id) ->
  UserPresences.update id, $set: state:"idle"

tick = (id) ->
  connections[id].lastSeen = Date.now()

Meteor.startup ->
  UserPresences.remove({})

Meteor.onConnection (connection) ->
  UserPresences.insert _id:connection.id
  connections[connection.id] = {}
  tick connection.id

  connection.onClose -> expire connection.id

Meteor.methods
  userPresenceTick: ->
    check arguments, [Match.Any]
    if @.connection and connections[@.connection.id]
      tick @.connection.id

Meteor.setInterval ->
  _.each connections, (connection, id) ->
    if connection.lastSeen < (Date.now() - idleDelay)
      idle id
, tickDelay
