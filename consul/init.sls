{% from "consul/map.jinja" import consul with context %}

consul:
  pkg.installed:
    - pkgs: {{ consul.pkgs }}
  service:
    - running
    - name: {{ consul.service }}
    - enable: True
    - require:
      - pkg: consul
