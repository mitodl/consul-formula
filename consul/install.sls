{% from "consul/map.jinja" import consul with context %}

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

{% for product, version in consul.products.items() %}
install_{{ product }}_binary:
  archive.extracted:
    - name: /usr/local/bin/
    - source: https://releases.hashicorp.com/{{ product }}/{{ version }}/{{ product }}_{{ version }}_linux_{{ consul.architecture_dict[grains['osarch']] }}.zip
    - source_hash: https://releases.hashicorp.com/{{ product }}/{{ version }}/{{ product }}_{{ version }}_SHA256SUMS
    - source_hash_name: {{ product }}_{{ version }}_linux_{{ consul.architecture_dict[grains['osarch']] }}.zip
    - archive_format: zip
    - if_missing: /usr/local/bin/{{ product }}
    - enforce_toplevel: False
    - failhard: True
  file.managed:
    - name: /usr/local/bin/{{ product }}
    - mode: 0755
    - require:
        - archive: install_{{ product }}_binary
    - require_in:
        - service: start_{{ product }}_service

{{ product }}_config_directory:
  file.directory:
    - name: /etc/{{ product }}.d/
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

configure_{{ product }}_service:
  file.managed:
    - name: /etc/systemd/system/{{ product }}.service
    - source: salt://consul/templates/{{ product }}.service
    - template: jinja
    - require_in:
      - service: start_{{ product }}_service
  cmd.wait:
    - name: systemctl daemon-reload
    - watch:
        - file: configure_{{ product }}_service
    - require_in:
      - service: start_{{ product }}_service
{% endfor %}

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

