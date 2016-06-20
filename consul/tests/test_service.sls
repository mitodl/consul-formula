test_consul_service_running:
  testinfra.service:
    - name: consul
    - is_running: True
    - is_enabled: True
