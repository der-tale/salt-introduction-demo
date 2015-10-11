include:
  - sun-java
  - sun-java.env

app-root:
  file.directory:
    - name: {{ salt['pillar.get']('app:root', '/dev/null') }}/
    - user: {{ salt['pillar.get']('app:user', 'nobody') }}
    - group: {{ salt['pillar.get']('app:group', 'nobody') }}
    - mode: 770
    - makedirs: True

app-available:
  file.managed:
    - name: {{ salt['pillar.get']('app:executable', '/dev/null') }}
    - source: salt://app.jar
    - user: {{ salt['pillar.get']('app:user', 'nobody') }}
    - group: {{ salt['pillar.get']('app:group', 'nobody') }}
    - mode: 770

app-java-config:
  file.managed:
    - name: {{ salt['pillar.get']('app:config') }}
    - source: salt://app.conf.tmpl
    - user: {{ salt['pillar.get']('app:user') }}
    - group: {{ salt['pillar.get']('app:group') }}
    - mode: 660

app-create-service:
  file.managed:
    - name: /etc/systemd/system/{{ salt['pillar.get']('app:name', "") }}.service
    - source: salt://java.service.tmpl
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - context:
        name: {{ salt['pillar.get']('app:name') }}
        executable: {{ salt['pillar.get']('app:executable') }}
        user: {{ salt['pillar.get']('app:user') }}

  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: /etc/systemd/system/{{ salt['pillar.get']('app:name', "") }}.service

app-running:
    service.running:
    - name: {{ salt['pillar.get']('app:name', "") }}
    - enable: True
    - require:
      - file: app-available
      - file: app-create-service
      - file: app-java-config
