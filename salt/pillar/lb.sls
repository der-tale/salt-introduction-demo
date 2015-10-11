apache:
  user: vagrant
  group: vagrant
  modules:
    enabled:
      - rewrite
      - proxy
      - proxy_fcgi
      - proxy_http
      - proxy_balancer
      - alias
      - lbmethod_byrequests
      - slotmem_shm
    disabled:
      - php5
  sites:
    app:
      enabled: True
      name: app
      template_file: salt://apache-lb.tmpl
      ServerName: salt-demo-master.dev
      ErrorLog: ${APACHE_LOG_DIR}/app-error.log
      CustomLog: ${APACHE_LOG_DIR}/app-access.log
      balancer:
        app-balancer:
          nodes:
            by_grain_roles: app
            port: 8080
          proxy:
            from: /
