{% from "consul/map.jinja" import consul with context %}

include:
  - .service

{% for name, contents in salt.pillar.get('consul:extra_configs', {}).items() %}
write_{{ name }}_config:
  file.managed:
    - name: {{ consul.config_dir }}/{{ name }}.json
    - contents: |
        {{ contents|tojson(indent=2)|indent(8) }}
    - makedirs: True
    - user: {{ consul.user }}
    - group: {{ consul.group }}
    - watch_in:
      - service: start_consul_service
{% endfor %}
