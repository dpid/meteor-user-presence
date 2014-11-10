Package.describe({
  name: "dpid:user-presence",
  summary: "Track which users are online or idle",
  version: "1.0.0",
  git: "https://github.com/dpid/meteor-user-presence.git"
});

Package.onUse(function (api) {
  api.versionsFrom('1.0');

  api.use('accounts-base');
  api.use(['coffeescript', 'underscore']);
  api.use('mongo');
  api.use(['deps', 'jquery'], 'client');

  api.add_files('lib/common.coffee', ['client', 'server']);
  api.add_files('lib/client.coffee', 'client');
  api.add_files('lib/server.coffee', 'server');

  api.export('UserPresences', ['client', 'server']);
  api.export('UserPresence', ['client', 'server']);
  api.export('UserPresenceSettings', 'server');
});
