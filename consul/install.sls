{% from "consul/map.jinja" import consul, consul_service with context %}

# At the time of writing, Hashicorp doesn't maintain any official package
# repositories for common linux distributions. The recommended installation
# method is to download a zip, verify it, and extract consul into the system
# path.

include:
  - .config
  - .service

create_consul_user:
  user.present:
    - name: {{ consul.user }}
    - createhome: False
    - shell: /bin/false

install_consul_binary:
  archive.extracted:
    - name: /usr/local/bin/
    - source: https://releases.hashicorp.com/consul/{{ consul.version }}/consul_{{ consul.version }}_linux_{{ consul.architecture_dict[grains['osarch']] }}.zip
    - source_hash: https://releases.hashicorp.com/consul/{{ consul.version }}/consul_{{ consul.version }}_SHA256SUMS
    - source_hash_name: ./{{ consul.version }}/consul_{{ consul.version }}_linux_amd64.zip
    - archive_format: zip
    - if_missing: /usr/local/bin/consul
    - enforce_toplevel: False
    - failhard: True
  file.managed:
    - name: /usr/local/bin/consul
    - mode: 0755
    - require:
        - archive: install_consul_binary
    - require_in:
        - service: start_consul_service

consul_data_directory:
  file.directory:
    - name: {{ consul.data_dir }}
    - user: {{ consul.user }}
    - group: {{ consul.group }}
    - makedirs: True
    - recurse:
        - user
        - group
    - require:
        - user: create_consul_user
    - require_in:
      - file: configure_consul_service

consul_config_directory:
  file.directory:
    - name: {{ consul.config_dir }}
    - name: {{ consul.data_dir }}
    - user: {{ consul.user }}
    - group: {{ consul.group }}
    - makedirs: True
    - recurse:
        - user
        - group
    - require:
        - user: create_consul_user
    - require_in:
      - file: configure_consul_service

configure_consul_service:
  file.managed:
    - name: {{ consul_service.destination_path }}
    - source: salt://consul/templates/{{ consul_service.source_path }}
    - template: jinja
    - require_in:
      - service: start_consul_service
  {% if salt.grains.get('init') == 'systemd' %}
  cmd.wait:
    - name: systemctl daemon-reload
    - watch:
        - file: configure_consul_service
    - require_in:
      - service: start_consul_service
  {% endif %}
