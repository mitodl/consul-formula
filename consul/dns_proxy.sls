{% from "consul/map.jinja" import consul with context %}
{#
  The Consul DNS interface runs on port 8600 by default, whereas the default
  port for DNS is 53. Additionaly, resolv.conf does not allow you to specify
  an alternative port for your nameservers. The way to circumvent this issue,
  aside from running the Consul agent as root, is to run a DNSMasq proxy to
  forward requests to the Consul agent on localhost.
#}

install_dnsmasq:
  pkg.installed:
    - name: dnsmasq

configure_dnsmasq:
  file.managed:
    - name: /etc/dnsmasq.d/10-consul
    - contents: 'server=/consul/127.0.0.1#{{ consul.dns_port }}'

install_resolvconf:
  pkg.installed:
    - name: resolvconf

configure_resolvconf:
  file.prepend:
    - name: /etc/resolvconf/resolv.conf.d/head
    - text: nameserver 127.0.0.1
    - require:
        - pkg: install_resolvconf

reload_resolvconf:
  cmd.run:
    - name: resolvconf -u
    - require:
        - file: configure_resolvconf

dnsmasq_service_running:
  service.running:
    - name: dnsmasq
    - enable: True
    - watch:
        - file: configure_dnsmasq
