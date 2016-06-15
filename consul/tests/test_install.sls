test_consul_installed:
  testinfra.file:
    - name: /usr/bin/consul
    - exists: True
