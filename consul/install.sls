{% from "consul/map.jinja" import consul, consul_service with context %}

# At the time of writing, Hashicorp doesn't maintain any official package
# repositories for common linux distributions. The recommended installation
# method is to download a zip, verify it, and extract consul into the system
# path.

include:
  - .service
  - .config

install_consul_binary:
  archive.extracted:
    - name: /usr/bin/
    - source: {{ consul.consul_zip }}
    - source_hash: {{ consul.consul_zip_checksum }}
    - archive_format: zip
    - if_missing: /usr/bin/consul

permission_consul_bin:
  file.managed:
    - name: /usr/bin/consul
    - mode: 0755
    - require:
      - archive: install_consul_binary

consul_data_directory:
  file.directory:
    - name: {{ consul.data_dir }}
    - makedirs: True
    - require_in:
      - service: configure_consul_service

consul_config_directory:
  file.directory:
    - name: {{ consul.config_dir }}
    - makedirs: True
    - require_in:
      - service: configure_consul_service

configure_consul_service:
  file.managed:
    - name: {{ consul_service.destination_path }}
    - source: salt://consul/templates/{{ consul_service.source_path }}
    - template: jinja
    - require_in:
      - service: start_consul_service
    - watch_in:
      - service: start_consul_service
