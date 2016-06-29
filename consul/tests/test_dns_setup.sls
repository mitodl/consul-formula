test_dnsmasq_installed:
  testinfra.package:
    - name: dnsmasq
    - is_installed: True

test_dnsmasq_consul_configured:
  testinfra.file:
    - name: /etc/dnsmasq.d/10-consul
    - exists: True
    - contains:
        parameter: server=/consul/127.0.0.1
        expected: True
        comparison: is_

test_resolv_conf_configured:
  testinfra.file:
    - name: /etc/resolv.conf
    - contains:
        parameter: nameserver 127.0.0.1
        expected: True
        comparison: is_

test_dnsmasq_running:
  testinfra.service:
    - name: dnsmasq
    - is_running: True
    - is_enabled: True

test_dnsmasq_listening:
  testinfra.socket:
    - name: tcp://127.0.0.1:53
    - is_listening: True

test_consul_dns_listening:
  testinfra.socket:
    - name: tcp://127.0.0.1:8600
    - is_listening: True

test_consul_dns_listening:
  testinfra.socket:
    - name: udp://127.0.0.1:8600
    - is_listening: True
