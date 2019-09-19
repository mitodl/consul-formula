{% from "consul/map.jinja" import consul with context %}

include:
  - .service

{% for name, contents in salt.pillar.get('consul:extra_configs', {}).items() %}
write_{{ name }}_config:
  file.managed:
    - name: {{ consul.config_dir }}/{{ name }}.json
    - contents: |
        {{ contents|json(indent=2, sort_keys=True)|indent(8) }}
    - makedirs: True
    - watch_in:
      - service: start_consul_service
{% endfor %}

configure_systemd_resolved_conf:
  file.append:
    - name: /etc/systemd/resolved.conf
    - text: |
        DNS=127.0.0.1
        Domains=~consul

{% for protocol in ['udp', 'tcp'] %}
redirect_{{ protocol }}_dns_port_to_consul_port:
  iptables.append:
    - table: nat
    - chain: OUTPUT
    - destination: localhost
    - protocol: {{ protocol }}
    - match:
        - protocol
    - dport: 53
    - jump: REDIRECT
    - to-ports: {{ consul.dns_port }}
    - comment: "Redirect {{ protocol }} DNS port to consul {{ consul.dns_port }} port"
    - save: True
{% endfor %}
