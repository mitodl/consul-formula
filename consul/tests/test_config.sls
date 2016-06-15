{% from "consul/map.jinja" import consul with context %}

{% for name, contents in salt.pillar.get('consul:extra_configs', {}).items() %}
test_{{ name }}_config_file:
  testinfra.file:
    - name: {{ consul.config_dir }}/{{ name }}.json
    - exists: True
{% endfor %}
