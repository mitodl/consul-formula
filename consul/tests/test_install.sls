{% from "consul/map.jinja" import consul, consul_service with context %}

test_consul_installed:
  testinfra.file:
    - name: /usr/local/bin/consul
    - exists: True
    - is_file: True
    - mode:
        expected: 493
        comparison: eq

{% for dir in [consul.data_dir, consul.config_dir] %}
test_{{ dir }}_dir_exists:
  testinfra.file:
    - name: {{ dir }}
    - is_directory: True
{% endfor %}

test_consul_service_script:
  testinfra.file:
    - name: {{ consul_service.destination_path }}
    - exists: True

test_consul_service_enabled:
  testinfra.service:
    - name: consul
    - is_enabled: True
    - is_running: True
