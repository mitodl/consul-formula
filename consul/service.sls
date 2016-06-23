start_consul_service:
  service.running:
    - name: consul
    - enable: True
