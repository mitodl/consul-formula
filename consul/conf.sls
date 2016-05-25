{% from "consul/map.jinja" import consul, consul_config with context %}

include:
  - consul

consul-config:
  file.managed:
    - name: {{ consul.conf_file }}
    - source: salt://consul/templates/conf.jinja
    - template: jinja
    - context:
      config: {{ consul_config }}
    - watch_in:
      - service: consul
    - require:
      - pkg: consul
