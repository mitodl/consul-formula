include:
  - .install
  - .service

{% for product in consul.products %}
rename_old_{{ product }}_binary_for_backup:
  file.rename:
    - name: /usr/local/bin/{{ product }}.bak
    - source: /usr/local/bin/{{ product }}
    - require_in:
        - archive: install_consul_binary
{% endfor %}

extend:
{% for product in consul.products %}
  start_{{ product }}_service:
    service:
      - reload: False
      - watch:
          - archive: install_{{ product }}_binary
{% endfor %}
