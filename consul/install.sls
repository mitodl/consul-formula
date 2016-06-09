{% from "consul/map.jinja" import consul with context %}

download_package:
  file.managed:
    - name: /tmp/consul.zip
    - source: {{ consul.consul_zip }}
    - source_hash: {{ consul.consul_zip_checksum }}

unzip_package:
  module.run:
    - name: archive.unzip
    - zip_file: /tmp/consul.zip
    - dest: /tmp/consul
    - require:
      - file: download_package

install_consul_bin:
  file.copy:
    - name: /tmp/consul/consul
    - dest: /usr/bin/consul
    - require:
      - module: unzip_package
