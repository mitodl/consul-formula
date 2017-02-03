include:
  - .install
  - .service

rename_old_consul_binary_for_backup:
  file.rename:
    - name: /usr/local/bin/consul.bak
    - source: /usr/local/bin/consul
    - require_in:
        - archive: install_consul_binary

extend:
  start_consul_service:
    service:
      - reload: False
      - watch:
          - archive: install_consul_binary
