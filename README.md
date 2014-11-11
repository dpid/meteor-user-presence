# Meteor User Presence

Track which users are online or idle.

### Example
[https://github.com/dpid/meteor-chat-room](https://github.com/dpid/meteor-chat-room)

## Installation

``` sh
$ meteor add dpid:user-presence
```

## Usage

Once added to your project, a new Meteor collection called `UserPresences` is available.

All authenticated connections are then stored in this collection. A presence document will contain the following
fields:

* _id - The connection id
* userId - The connection user id
* state - The current presence state. Values are either "online" or "idle".
* data (optional) - Any arbitrary data you want to keep track of with a connection.


NOTE: The package doesn't publish the presences by default. You'll want to set one up like so in the server:
```js
Meteor.publish('userPresence', function() {
  // Example of using a filter to publish only "online" users:
  var filter = {state: "online"};
  return UserPresences.find(filter);
});
```

You'll also want to setup a corresponding subscribe in the client:

```js
Meteor.subscribe('userPresence');
```

## Optional Data function

If you want to track more than just users' online state, you can setup an optional data field:

```js
// Setup the state function on the client
UserPresence.data = function() {
  return {
    roomId: Session.get('roomId')
  };
}
```

Now, simply query the collection to find all other users that share the same roomId

```js
UserPresences.find({ 'data.roomId': { roomId: Session.get('roomId') }});
```

Meteor will call your function reactively, so everyone will see changes to the data dynamically.

## Advanced Settings

To further tweak things, you can define optional settings on the server via UserPresenceSettings.

```js
UserPresenceSettings({
  idleDelay: 10000, // How long it takes to go idle
  tickDelay: 5000, // How often the server will check for idle
  onDisconnect: function(userPresence){} // Do something with userPresence data on user disconnect
});
```
