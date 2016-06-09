{% from "consul/map.jinja" import consul, consul_service with context %}

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
    - name: /usr/bin/consul
    - source: /tmp/consul/consul
    - require:
      - module: unzip_package

consul_config_directory:
  file.directory:
    - name: /etc/consul.d
    - makedirs: True

configure_consul_service:
  file.managed:
    - name: {{ consul_service.destination_path }}
    - source: salt://consul/files/{{ consul_service.source_path }}
