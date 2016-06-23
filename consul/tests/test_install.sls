{% from "consul/map.jinja" import consul, consul_service with context %}

test_consul_installed:
  testinfra.file:
    - name: /usr/bin/consul
    - exists: True

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
