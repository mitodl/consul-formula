{% from "consul/map.jinja" import consul with context %}

include:
  - .service

{% for name, contents in salt.pillar.get('consul:extra_configs', {}).items() %}
write_{{ name }}_config:
  file.managed:
    - name: {{ consul.config_dir }}/{{ name }}.json
    - contents: |
        {{ contents|json }}
    - makedirs: True
    - require:
      - file: consul_config_directory
    - watch_in:
      - service: start_consul_service
{% endfor %}
