{% from "consul/map.jinja" import consul with context %}

include:
  - .install

{% for name, contents in salt.pillar.get('consul:extra_configs', {}).items() %}
write_{{ name }}_config:
  file.managed:
    - name: {{ consul.config_dir }}/{{ name }}.json
    - contents: |
        {{ contents|json }}
    - require:
      - file: consul_config_directory
    - require_in:
      - start_consul_service
    - watch_in:
      - start_consul_service
{% endfor %}
