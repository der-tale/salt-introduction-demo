app:
  root: /opt/app
  user: vagrant
  group: vagrant
  executable: /opt/app/app.jar
  name: app
  config: /opt/app/app.conf

mine_functions:
  network.ip_addrs: [eth1]
