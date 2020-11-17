{% from "consul/map.jinja" import consul with context %}

{% for product in consul.products %}
start_{{ product }}_service:
  service.running:
    - name: {{ product }}
    - enable: True
    - reload: True
{% endfor %}
