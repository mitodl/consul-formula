include:
  - .install

start_consul_service:
  service.running:
    - name: consul
    - enable: True
    - require:
      - configure_consul_service
